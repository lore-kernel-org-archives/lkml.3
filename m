Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3IWFQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 01:16:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:57411 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab3IWFQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 01:16:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,960,1371106800"; 
   d="scan'208";a="298072094"
Date: Mon, 23 Sep 2013 09:55:49 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lu Jingchang-B35083 <B35083@freescale.com>
Cc: "djbw@fb.com" <djbw@fb.com>, "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20130923042549.GC17188@intel.com>
References: <1378374799-16357-1-git-send-email-b35083@freescale.com>
 <20130917045359.GN17188@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E85223E21@039-SN1MPN1-003.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B56CDBE15CE27145A4B77D2D24263E85223E21@039-SN1MPN1-003.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 08:08:46AM +0000, Lu Jingchang-B35083 wrote:
> > > +	case DMA_PAUSE:
> > > +		if (fsl_chan->edesc)
> > > +			fsl_edma_disable_request(fsl_chan);
> > racy here too...
> It only set the channel HW register, no list is handled, 
> is lock needed here? Thanks!
well thats the point while you are terminating the current trasnaction can
complete and then start another one. You want to try and prevent these case
also. Here you are neither locking the HW access nor the the list, so its juts
waiting to crash!

~Vinod
-- 
