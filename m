Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaLESkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:40:04 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45483 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaLESkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:40:01 -0500
Date: Fri, 5 Dec 2014 18:39:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: using DMA-API on ARM
Message-ID: <20141205183945.GE31222@e104818-lin.cambridge.arm.com>
References: <5481794E.4050406@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5481794E.4050406@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 09:22:22AM +0000, Arend van Spriel wrote:
> For our brcm80211 development we are working on getting brcmfmac driver
> up and running on a Broadcom ARM-based platform. The wireless device is
> a PCIe device, which is hooked up to the system behind a PCIe host
> bridge, and we transfer information between host and device using a
> descriptor ring buffer allocated using dma_alloc_coherent(). We mostly
> tested on x86 and seen no issue. However, on this ARM platform
> (single-core A9) we detect occasionally that the descriptor content is
> invalid. When this occurs we do a dma_sync_single_for_cpu() and this is
> retried a number of times if the problem persists. Actually, found out
> that someone made a mistake by using virt_to_dma(va) to get the
> dma_handle parameter. So probably we only provided a delay in the retry
> loop. After fixing that a single call to dma_sync_single_for_cpu() is
> sufficient. The DMA-API-HOWTO clearly states that:

Does your system have an L2 cache? What's the SoC topology, can PCIe see
such L2 cache (or snoop the L1 caches)?

Also, are you certain that dma_alloc_coherent() ends up creating a
non-cacheable mapping in Linux (this call translates to a function
pointer call which may or may not create non-cacheable memory, depending
on the "dma-coherent" property passed via DT).

-- 
Catalin
