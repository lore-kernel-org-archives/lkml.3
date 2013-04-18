Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965816Ab3DRNnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:43:23 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:53127 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934480Ab3DRNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:43:22 -0400
Date: Thu, 18 Apr 2013 14:43:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 24/32 v2] dmaengine: ste_dma40: Supply full Device Tree
 parsing support
Message-ID: <20130418134316.GA3959@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-25-git-send-email-lee.jones@linaro.org>
 <20130418121253.GF27903@gmail.com>
 <201304181432.11503.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304181432.11503.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Arnd Bergmann wrote:

> On Thursday 18 April 2013, Lee Jones wrote:
> > +Clients
> > +Required properties:
> > +- dmas: Comma separated list of dma channel requests
> > +- dma-names: Names of the aforementioned requested channels
> > +
> > +Each dmas request consists of 4 cells:
> > +  1. A phandle pointing to the DMA controller
> > +  2. Device Type
> > +  3. The DMA request line number (only when 'use fixed channel' is set)
> > +  4. A 32bit mask specifying; mode, direction and endianess [NB: This list will grow]
> > +        bit 1: Mode:
> > +           0: Logical
> > +           1: Physical
> > +        bit 2: Direction:
> > +           0: Mem to Mem
> > +           1: Mem to Dev
> 
> You probably mean 
> 
> 		0: Dev to mem
> 
> Related to this, I would recommend not listing bit numbers like this, since there
> is some amount of confusion regarding how they are counted: zero-based on one-based
> and LSB-to-MSB or MSB-to-LSB
> 
> You can completely avoid this problem by listing them as bit masks:
> 
> 	0x00000002:
> 		Logical channel when unset
> 		Physical channel when set
> 	0x00000004:
> 		Direction from device when unset
> 		Direction to device when unset
> 	... 
> 
> > +		dmas = <&dma 13 0 0x8>, /* Logical - DevToMem */
> > +		       <&dma 13 0 0x4>; /* Logical - MemToDev */
> 
> The bit in the example no longer matches the description.
> 
> > +
> > +	switch (D40_DT_FLAGS_DIR(flags)) {
> > +	case 0: cfg.dir = STEDMA40_MEM_TO_MEM; break;
> > +	case 1: cfg.dir = STEDMA40_MEM_TO_PERIPH; break;
> > +	}
> 
> Same typo above.
> 
> > +	if (cfg.dir == STEDMA40_PERIPH_TO_MEM)
> > +		cfg.src_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
> > +	if (cfg.dir == STEDMA40_MEM_TO_PERIPH)
> > +		cfg.dst_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
> 
> You can fold these two into the switch statement above.

This is what happens when you rush a fixup. :)

I'll do it properly now.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
