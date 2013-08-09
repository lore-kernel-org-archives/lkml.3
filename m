Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031038Ab3HIUT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:19:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030954Ab3HIUT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:19:26 -0400
Subject: Re: Question about REQ_FLUSH and bios with data
From: Steven Whitehouse <swhiteho@redhat.com>
To: scameron@beardog.cce.hp.com
Cc: linux-kernel@vger.kernel.org, jens.axboe@kernel.dk, tj@kernel.org
In-Reply-To: <20130809190934.GL9905@beardog.cce.hp.com>
References: <20130809190934.GL9905@beardog.cce.hp.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 09 Aug 2013 21:18:15 +0100
Message-ID: <1376079495.2718.15.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2013-08-09 at 14:09 -0500, scameron@beardog.cce.hp.com wrote:
> So, I'm working on a block driver using the make_request_fn
> interface, and have to handle a bio that comes in with
> (bi_rw & REQ_FLUSH) set AND data to transfer. 
> 
> According to Documentation/block/writeback_cache_control.txt:
> 
> 	The REQ_FLUSH flag can be OR ed into the r/w flags of a
> 	bio submitted from the filesystem and will make sure the
> 	volatile cache of the storage device has been flushed
> 	before the actual I/O operation is started. 
> 
> So I've written code that handles that case, along with the
> various error cases I might encounter, I think, which leads
> to my question:
> 
> How do I get such a bio with a data transfer AND the REQ_FLUSH bit
> set to come into the driver?   Just wondering how to test this case.
> 
GFS2 does this... if you look at the log flush code and the function
log_write_header() in particular, you'll see that it sets this on each
log header that gets written. You don't need a cluster to generate this
kind of i/o, just supply mkfs.gfs2 with -p lock_nolock and mount it as a
local filesystem. The combination of touch foo; sync should be enough to
generate a log flush writing a log header with this flag set,

Steve.

> Thanks,
> 
> (I cc'ed Tejun Heo just because his name is in block/blk-flush.c)
> 
> -- steve
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


