Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaAGRzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:55:19 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58424 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752049AbaAGRzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:55:15 -0500
Date: Tue, 7 Jan 2014 17:55:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Regression (ARM) arch/arm/mm/init.c doesn't build without
	CONFIG_ARM_PATCH_PHYS_VIRT.
Message-ID: <20140107175505.GK27432@n2100.arm.linux.org.uk>
References: <m38uv1uuzr.fsf@t19.piap.pl> <m3ha9gx63v.fsf@t19.piap.pl> <20140106223906.GH27432@n2100.arm.linux.org.uk> <52CB3F55.1050404@ti.com> <20140107011121.GI27432@n2100.arm.linux.org.uk> <52CC3D46.3090102@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CC3D46.3090102@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 12:45:42PM -0500, Santosh Shilimkar wrote:
> On Monday 06 January 2014 08:11 PM, Russell King - ARM Linux wrote:
> > /--------------------------------------------------------------
> > | > > Right, so, with Assabet, which has CONFIG_DMA_ZONE=y and
> > | > > CONFIG_ARM_PATCH_PHYS_VIRT=y:
> > | > > 
> > | > > $ make O=../build/assabet arch/arm/mm/init.i
> > | > > 
> > | > > gives:
> > | > >   arm_dma_limit = __pv_phys_offset + arm_dma_zone_size - 1;
> > | > > 
> > | > > with or without Santosh's patch.
> > \--------------------------------------------------------------
> > 
> >> May be I missed your point but I ended up creating the patch because
> >> the CMA reservation was failing on Keystone since the arm_dma_limit
> >> wasn't right since it wasn't considering the actual __pv_phys_offset.
> >>
> >> Isn't that an issue ?
> > 
> > See the above.  Your patch has _no_ effect what so ever when
> > CONFIG_ARM_PATCH_PHYS_VIRT=y - which you have on the Keystone, right?
> > 
> > If you don't believe me, ask make to produce arch/arm/mm/init.i, which
> > is the output from the preprocessor, comparing the resulting generated
> > file both with and without your patch applied.
> > 
> Looks like you are right. I did two fixes to have right arm_dma_limit in
> below order.
> 
> 1. 787b0d5 {ARM: 7908/1: mm: Fix the arm_dma_limit calculation}
> 2. 7c92732 {ARM: 7909/1: mm: Call setup_dma_zone() post early_paging_init()}
> 
> But with 2 alone the issue gets fixed since with ARM_PATCH_PHYS_VIRT and
> below pre-processor, the PHYS_OFFSET also gets an updated value. I never
> realised that 1 becomes redundant after second patch while creating them. 
> 
> #define PHYS_OFFSET __pv_phys_offset
> 
> So indeed, 787b0d5{ARM: 7908/1: mm: Fix the arm_dma_limit calculation}
> won't be needed anymore and can be reverted. Sorry it took some time
> for me to reach to your conclusion.

Okay, reverted.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
