Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbaKTOOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:14:34 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63409 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaKTOOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:14:32 -0500
Message-ID: <546DF745.1070901@plexistor.com>
Date: Thu, 20 Nov 2014 16:14:29 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Boaz Harrosh <boaz@plexistor.com>
CC: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
References: <20141113220927.GF2598@htj.dyndns.org> <20141113221139.GG2598@htj.dyndns.org> <546DC5AD.3040606@plexistor.com> <20141120115052.GA32237@htj.dyndns.org> <546DE065.3090502@plexistor.com> <20141120131118.GB14877@htj.dyndns.org>
In-Reply-To: <20141120131118.GB14877@htj.dyndns.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 03:11 PM, Tejun Heo wrote:
> Hello, Boaz.
> 
<>
> W/ preloading, one way to do it is,
> 
> 	if (preload())
> 		handle -ENOMEM;
> 	lock;
> 	error = insert();
> 	if (error)
> 		handle error which can't be -ENOMEM;
> 	unlock;
> 	preload_end();
> 

I like this one, cause of the place I come from. Where
in a cluster you want the local fails as early as possible
before you start to commit remotely, and need to undo on
errors.

And I can see the real flow of things

> Another way is
> 
> 	preload();	// can't fail
> 	lock;
> 	error = insert();
> 	if (error)
> 		handle error;'
> 	unlock;
> 	preload_end();
> 
> Both ways have pros and cons.  The latter seems to lead to simpler
> code in general.  Not always, but the overall.
> 

I still like the over all simplicity of the above pattern to
this behind the seen complexity hidden away under the carpet.

But I guess that is just me. That is your call sir.

I do see your point though.

<>
> 
> And that's why the pattern usually leads to simpler code - it doesn't
> create a new failure point.
> 

Again a matter of taste. I like the extra ENOMEM failure point before
I started to commit to any state changes, lock grabbing and unrolling
in case of errors.

But I see your points as well. For what it is worth I have reviewed
your code and did not find any faults in it. It looks like sound
code.

Thanks
Boaz

