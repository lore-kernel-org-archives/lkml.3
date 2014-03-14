Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbaCNOUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:20:41 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:50201 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbaCNOUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:20:40 -0400
Date: Fri, 14 Mar 2014 10:20:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
Message-ID: <20140314142036.GI12613@htj.dyndns.org>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
 <20140218155945.ee2e22e07fa3b4f242b16a7f@linux-foundation.org>
 <CACZ9PQV8RsaefFAOt5b-aL33G3CiD+3+fTuW15io6u1DH3XJ6Q@mail.gmail.com>
 <CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
 <20140313200119.GB504@quack.suse.cz>
 <20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
 <20140314130712.GC12613@htj.dyndns.org>
 <CACZ9PQUQX-sSNo+z0LB0Tefq9pSHFr6GjKg2tWzdAtw3OYYDsg@mail.gmail.com>
 <20140314141143.GH12613@htj.dyndns.org>
 <CACZ9PQWtHJh6j_bKwB-HF4h3rU3813AN2qUibkCs7tmXUrLJoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ9PQWtHJh6j_bKwB-HF4h3rU3813AN2qUibkCs7tmXUrLJoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 11:17:56PM +0900, Roman Peniaev wrote:
> No, no. Not device does not support flush, filesystem does not care about flush.
> (take any old school, e.g. ext2)
> 
> We did some write, and then we did fsync.
> But filesystem does not support REQ_FLUSH/FUA so block device will never
> get the checkpoint where it should really flush everything.
> 
> So, fsync will not guarantee any integrity in that case.

Oh, no idea.  Fix the filesystem to support REQ_FLUSH?  :)

-- 
tejun
