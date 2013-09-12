Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3ILRgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:36:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54468 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3ILRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:36:49 -0400
Date: Thu, 12 Sep 2013 18:35:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] dma: use %pa to print dma_addr_t
Message-ID: <20130912173554.GQ12758@n2100.arm.linux.org.uk>
References: <1378960710-15648-1-git-send-email-olof@lixom.net> <5231F45C.3020500@infradead.org> <CAOesGMi2VkBzvXtK9eftViaWBRFGdv6TgzYZ6NCKQfhKWZGVWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMi2VkBzvXtK9eftViaWBRFGdv6TgzYZ6NCKQfhKWZGVWA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:11:44AM -0700, Olof Johansson wrote:
> Any >32bit-addressable machine will likely want 64-bit dma_addr_t as
> well. The only architecture that doesn't seem to set
> ARCH_DMA_ADDR_T_64BIT based on PHYS_ADDR_T size is ARM, and I think
> that should just be changed there as well.

Do we actually have any 64-bit DMA controllers out there?  As far as
I'm aware, all our DMA controllers are all 32-bit address only.  That
makes a 64-bit dma_addr_t rather silly.

Remember that dma_addr_t is the value you program into the DMA
controller, and _not_ the actual physical address.
