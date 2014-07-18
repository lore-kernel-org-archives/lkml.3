Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbaGRJqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:46:03 -0400
Received: from verein.lst.de ([213.95.11.211]:48719 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761364AbaGRJqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:46:01 -0400
Date: Fri, 18 Jul 2014 11:45:59 +0200
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
Subject: Re: [PATCH 2/3] blk-mq: pass along blk_mq_alloc_tag_set return
	values
Message-ID: <20140718094559.GB2121@lst.de>
References: <20140717193707.1924.87867.stgit@beardog.cce.hp.com> <20140717193915.1924.24620.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717193915.1924.24620.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 02:39:21PM -0500, Robert Elliott wrote:
> Two of the blk-mq based drivers do not pass back the return value
> from blk_mq_alloc_tag_set, instead just returning -ENOMEM.
> 
> blk_mq_alloc_tag_set returns -EINVAL if the number of queues or
> queue depth is bad.  -ENOMEM implies that retrying after freeing some
> memory might be more successful, but that won't ever change
> in the -EINVAL cases.
> 
> Change the null_blk and mtip32xx drivers to pass along
> the return value.
> 
> Signed-off-by: Robert Elliott <elliott@hp.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
