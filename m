Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab3ILRpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:45:14 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48064 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab3ILRpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:13 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130912173554.GQ12758@n2100.arm.linux.org.uk>
References: <1378960710-15648-1-git-send-email-olof@lixom.net>
	<5231F45C.3020500@infradead.org>
	<CAOesGMi2VkBzvXtK9eftViaWBRFGdv6TgzYZ6NCKQfhKWZGVWA@mail.gmail.com>
	<20130912173554.GQ12758@n2100.arm.linux.org.uk>
Date: Thu, 12 Sep 2013 10:45:11 -0700
Message-ID: <CAOesGMj8NSgSEz0H2gzgMsk_fi-kx=qM+=4qy4b6-vSsHkVfoA@mail.gmail.com>
Subject: Re: [PATCH] dma: use %pa to print dma_addr_t
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Randy Dunlap <rdunlap@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:35 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Sep 12, 2013 at 10:11:44AM -0700, Olof Johansson wrote:
>> Any >32bit-addressable machine will likely want 64-bit dma_addr_t as
>> well. The only architecture that doesn't seem to set
>> ARCH_DMA_ADDR_T_64BIT based on PHYS_ADDR_T size is ARM, and I think
>> that should just be changed there as well.

The thread Joe linked to refers to a comment that is now deleted;
sparc64 apparantly has 32-bit dma_addr_t at least, so there are
platforms where the two differ permanently. Adding a new printk format
is probably needed here after all.

> Do we actually have any 64-bit DMA controllers out there?  As far as
> I'm aware, all our DMA controllers are all 32-bit address only.  That
> makes a 64-bit dma_addr_t rather silly.

PCI/PCI-e is the large unknown here, I'm not actually sure if any of
the current implementation of host controllers support it, but it
would seem likely that server-class hardware does.


-Olof
