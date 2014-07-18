Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbaGRJp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:45:26 -0400
Received: from verein.lst.de ([213.95.11.211]:48705 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbaGRJpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:45:25 -0400
Date: Fri, 18 Jul 2014 11:45:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Robert Elliott <elliott@hp.com>
Cc: axboe@kernel.dk, abhijit.mahajan@avagotech.com, kmo@datarainc.com,
        nagalakshmi.nandigama@avagotech.com, asamymuthupa@micron.com,
        snitzer@redhat.com, JBottomley@parallels.com,
        relliott@beardog.cce.hp.com, sreekanth.reddy@avagotech.com,
        praveen.krishnamoorthy@avagotech.com, agordeev@redhat.com,
        scameron@beardog.cce.hp.com, tom.leiming@gmail.com,
        sbradshaw@micron.com, hch@lst.de, m@bjorling.me,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] blk-mq: cleanup after blk_mq_init_rq_map failures
Message-ID: <20140718094518.GA2121@lst.de>
References: <20140717193707.1924.87867.stgit@beardog.cce.hp.com> <20140717193904.1924.84206.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717193904.1924.84206.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 02:39:09PM -0500, Robert Elliott wrote:
> In blk-mq.c blk_mq_alloc_tag_set, if:
> 	set->tags = kmalloc_node()
> succeeds, but one of the blk_mq_init_rq_map() calls fails,
> 	goto out_unwind;
> needs to free set->tags so the caller is not obligated
> to do so.  None of the current callers (null_blk,
> virtio_blk, virtio_blk, or the forthcoming scsi-mq)
> do so.
> 
> set->tags needs to be set to NULL after doing so,
> so other tag cleanup logic doesn't try to free
> a stale pointer later.  Also set it to NULL
> in blk_mq_free_tag_set.
> 
> Tested with error injection on the forthcoming
> scsi-mq + hpsa combination.
> 
> Signed-off-by: Robert Elliott <elliott@hp.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
