Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaEVDCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:02:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:28834 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaEVDCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,884,1392192000"; 
   d="scan'208";a="535792101"
Date: Thu, 22 May 2014 08:15:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, joelf@ti.com, arnd@arndb.de,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        tony@atomide.com, bcousson@baylibre.com
Subject: Re: [PATCH v3 00/13]  ARM/DT: edma: IP configuration from hardware
 and cleanups
Message-ID: <20140522024553.GS21128@intel.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
 <537A01F2.2090107@ti.com>
 <537A36F9.40004@ti.com>
 <537B34C9.1020508@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537B34C9.1020508@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 04:26:09PM +0530, Sekhar Nori wrote:
> On Monday 19 May 2014 10:23 PM, Peter Ujfalusi wrote:
> > On 05/19/2014 04:06 PM, Sekhar Nori wrote:
> >> On Friday 16 May 2014 05:47 PM, Peter Ujfalusi wrote:
> >>> Hi,
> >>>
> >>> Changes since v2:
> >>> - Comments from Sekhar and Arnd has been addressed best as I could.
> >>> - Use the CCCFG information in all cases instead of pdata provided information
> >>> - To achieve this I needed to do a bit more cleanup in this series
> >>> - In the documentation patch, retrain the old properties for reference
> >>> - Cleanups in the old davinci board files and removing edma_soc_info members
> >>>
> >>> Changes sicne v1:
> >>> - added missing patch to remove the memset from edma_of_parse_dt()
> >>>
> >>> We are requesting redundant information via DT for the driver since the very same
> >>> data is available in the HW: by reading and decoding the content of CCCFG
> >>> register we can get:
> >>> Number of channels: NUM_DMACH
> >>> Number of regions: NUM_REGN
> >>> Number of slots (PaRAM sets): NUM_PAENTRY
> >>> Number of TC/EQ: NUM_EVQUE
> >>>
> >>> So these does not need to be provided by the DT binding.
> >>>
> >>> The driver will no longer look for these properties from DT and they can be
> >>> removed from the binding documentation and from the dtsi files as well.
> >>> The change will not introduce regression when new kernel is booted using older
> >>> DTB (since we just ignore the mentioned properties).
> >>
> >> Applied all patches and pushed to branch v3.16/edma of:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci.git
> >>
> >> Since the patches did not apply cleanly, please verify. I tested on
> >> DA850 EVM using MMC/SD as EDMA user.
> > 
> > The patches in this series looks OK in your branch.
> > However I can not find the following commits in there, which I have in linux-next:
> > c689a7b79c28 Merge remote-tracking branch 'slave-dma/next'
> > cdae05a0f0f7 dmaengine: edma: Make reading the position of active channels work
> > cf7eb979116c ARM: common: edma: Fix xbar mapping
> > 232b223d8281 dmaengine: edma: Set DMA_CYCLIC capability flag
> > 7cf2af90cd51 arm: common: edma: Save the number of event queues/TCs
> > 
> > They might come via different route...
> 
> Vinod,
> 
> Do you have an immutable branch based on which I can send this patch
> series to ARM-SoC? Some of the patches in the series depend on code that
> went through your tree.
yup, pls pull my topic/edma for these change. This branch will not be rebased.

> Or if you are comfortable taking this series through your tree, thats
> okay by me too. We are still waiting for acks from DT maintainers on the
> binding change patches.
Since these patchs are for ARM, I think they are best suited thru arm tree. If
you run into issues with that I cna merge this but with right ACKs...

-- 
~Vinod
