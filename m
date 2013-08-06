Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3HFFFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:05:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:3824 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab3HFFFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,824,1367996400"; 
   d="scan'208";a="342239086"
Date: Tue, 6 Aug 2013 09:55:14 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lu Jingchang-B35083 <B35083@freescale.com>
Cc: "djbw@fb.com" <djbw@fb.com>, "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wang Huan-B18965 <B18965@freescale.com>,
        Li Xiaochun-B41219 <B41219@freescale.com>
Subject: Re: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20130806042514.GR29095@intel.com>
References: <1375682824-11443-1-git-send-email-b35083@freescale.com>
 <1375682824-11443-2-git-send-email-b35083@freescale.com>
 <20130805163444.GQ29095@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E851FD63C@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B56CDBE15CE27145A4B77D2D24263E851FD63C@039-SN1MPN1-004.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 01:24:31AM +0000, Lu Jingchang-B35083 wrote:
> > -----Original Message-----
> > From: Vinod Koul [mailto:vinod.koul@intel.com]
> > Sent: Tuesday, August 06, 2013 12:35 AM
> > To: Lu Jingchang-B35083
> > Cc: djbw@fb.com; shawn.guo@linaro.org; linux-kernel@vger.kernel.org;
> > linux-arm-kernel@lists.infradead.org; Wang Huan-B18965; Li Xiaochun-
> > B41219
> > Subject: Re: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
> > > +
> > > +static void fsl_edma_free_desc(struct virt_dma_desc *vdesc) {
> > > +	struct fsl_edma_desc *fsl_desc;
> > > +	int i;
> > > +
> > > +	fsl_desc = to_fsl_edma_desc(vdesc);
> > > +	for (i = 0; i < fsl_desc->n_tcds; i++)
> > > +			dma_pool_free(fsl_desc->echan->tcd_pool,
> > > +					fsl_desc->tcd[i].vtcd,
> > > +					fsl_desc->tcd[i].ptcd);
> > > +	kfree(fsl_desc);
> > should this be called with lock held or not?
> [Lu Jingchang-B35083] 
> The desc list to be freed is got with lock held, and the free for each desc is independent, and the lock is not needed. Thanks.
Would be apt to add this comment in the code, so that people know this function
needs to be always called with lock held!

Pls add this stuff in next rev of the patch

~Vinod
