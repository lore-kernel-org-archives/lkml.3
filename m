Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbaGRJqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:46:52 -0400
Received: from verein.lst.de ([213.95.11.211]:48726 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761228AbaGRJqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:46:51 -0400
Date: Fri, 18 Jul 2014 11:46:49 +0200
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
Subject: Re: [PATCH 3/3] mpt3sas, mpt2sas: fix scsi_add_host error handling
	problems in _scsih_probe
Message-ID: <20140718094649.GC2121@lst.de>
References: <20140717193707.1924.87867.stgit@beardog.cce.hp.com> <20140717193926.1924.21344.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717193926.1924.21344.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 02:39:30PM -0500, Robert Elliott wrote:
> In _scsih_probe, propagate the return value from scsi_add_host.
> In mpt3sas, avoid calling list_del twice if that returns an
> error, which causes list_del corruption warnings if an error
> is returned.
> 
> Tested with blk-mq and scsi-mq patches to properly cleanup
> from and propagate blk_mq_init_rq_map errors.
> 
> Signed-off-by: Robert Elliott <elliott@hp.com>

Looks good.  It would be even better if we'd have proper error values
returned from mpt2/3sas_base_attach as well.

Reviewed-by: Christoph Hellwig <hch@lst.de>
