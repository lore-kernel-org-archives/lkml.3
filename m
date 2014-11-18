Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaKRLzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:55:36 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:61099 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaKRLze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:55:34 -0500
Date: Tue, 18 Nov 2014 06:55:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
Message-ID: <20141118115530.GC7809@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
 <546B0F16.90901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B0F16.90901@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 18, 2014 at 05:19:18PM +0800, Lai Jiangshan wrote:
> Is it too ugly?

What is "it"?  The whole thing?  percpu preloading?  I'm just gonna
continue assuming that you're talking about preloading.  If you think
it's ugly, please go ahead and explain why you think it is.

It's almost impossible to respond to your "review".  It's not clear
what your subject matter or opinion on it is.  Might as well just bang
on the keyboard randomly.  When reviewing (or communicating in
general), please try to properly form and elaborate your points.
Other people can't know what's going on in your brain and have to
speculate what you could have meant.

This implementation of preloading an evolution of a design pattern
which, IIRC, first started with the radix tree.  The non-failing
aspect was introduced while the pattern was being applied to idr.  I
think it's one of the better ways to implement preloading.

> What will be the most important result it achieve?

This is the same as other preloading.  It allows pulling allocation
out of critical section so that it can be done with more generous
allocation mask (ie. GFP_KERNEL instead of GPF_NOWAIT).  It's a common
pattern found in data structures which may allocate memory internally
such as radix tree or idr.

Thanks.

-- 
tejun
