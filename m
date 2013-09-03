Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab3ICMSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:18:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:22815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759923Ab3ICMSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1014,1367996400"; 
   d="scan'208";a="397488324"
Date: Tue, 3 Sep 2013 17:01:51 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lu Jingchang-B35083 <B35083@freescale.com>
Cc: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20130903113151.GE15824@intel.com>
References: <1376633274-17850-1-git-send-email-b35083@freescale.com>
 <20130828081742.GC11414@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520A8C7@039-SN1MPN1-003.039d.mgd.msft.net>
 <20130902045050.GE7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520D0D4@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130902063721.GK7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520F101@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130902111200.GP7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E852102A1@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B56CDBE15CE27145A4B77D2D24263E852102A1@039-SN1MPN1-004.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 05:43:21AM +0000, Lu Jingchang-B35083 wrote:
>   Do you mean the DMA_SLAVE_CONFIG device_control? Yeah, the slave driver could pass
> the slave_id. But the DMA_SLAVE_CONFIG may be called more than once, and the eDMA
> driver just needs to set the slave id once for any given channel, after that the 
> transfer is transparent to the device. 
It depends, for a channel requested, if you are only tranferring to a particular
slave device then it can be confugured once.
so
1. allocate channel
2. dmaengine_slave_config()

then you cnan do preare etc multiple times based on need.

~Vinod
>   On the other hand, the DMAMUX's setting procedure requires first disable the dmamux
> before setting, then if it is set in DMA_SLAVE_CONFIG, the repeated setting may be
> complex and unnecessary. The channel is occupied exclusively by the peripheral.
>   So, according the HW feature, I think the eDMA needs only set the slave id once,
> and since the of_dma helper has pass the slave id in on xlate, we can get and set
> the slave id here. How do you think about this?

-- 
