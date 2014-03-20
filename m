Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbaCTQKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:10:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaCTQKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:10:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: Re: DMABOUNCE in pci-rcar
Date: Thu, 20 Mar 2014 17:09:57 +0100
Message-ID: <5527822.QYtFYiIpiW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <532B0384.1000400@codethink.co.uk>
References: <201402241200.21944.arnd@arndb.de> <5165962.7bqj51B15Z@wuerfel> <532B0384.1000400@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:paDq5zOBhfbvs/aqwF7nGfXdIXe6vmTdBR9YaKlaKek
 CvYyTRI+5cmLFOerX9LwczreIPHJeLr4Ud5gcehTOLLt0RCcBn
 sq+OQibodCKkZHDjeB4MSxklBYrp0ycflWJcRYmdYgC0ihY36y
 lZjw+AhKxZ/GbjU8bv/RHXb06lh6fQ/xWreDfWmUdT8IYnQICH
 NCElN7aGsmV3uBW32PBgocBBWn6kAm2UC3+TLP8miGC4XIAR2h
 3wEzD69Zt937x19JD9vwcMMxYXG3Qdis0qFAmlicSgkM0g7zmN
 sLA0inoX5yOZ6n/79UZjUlHrOXbhhmDJ5pYWyVdDgFGVQ8TgGd
 WaR6N3t8FaUq2gbaoPwA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014 16:04:36 Ben Dooks wrote:
> On 26/02/14 20:57, Arnd Bergmann wrote:
> > On Wednesday 26 February 2014 12:48:17 Bjorn Helgaas wrote:
> >> On Mon, Feb 24, 2014 at 4:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >>> Hi Magnus,
> >>>
> >>> I noticed during randconfig testing that you enabled DMABOUNCE for the
> >>> pci-rcar-gen2 driver as posted in this patch https://lkml.org/lkml/2014/2/5/30
> >>>
> >>> I didn't see the original post unfortunately, but I fear we have to
> >>> revert it and come up with a better solution, ...
> >>
> >> Sounds like I should drop the following patches from my pci/host-rcar
> >> branch for now?
> >>
> >>    PCI: rcar: Add DMABOUNCE support
> >>    PCI: rcar: Enable BOUNCE in case of HIGHMEM
> >>    PCI: rcar: Make the Kconfig dependencies more generic
> >
> > Sounds good to me. The last patch is actually fine, but you'll have to
> > fix the context to apply it without the other two.
> 
> As a note, if we now boot a Lager with DT on 3.14-rc3 series the USB
> controllers no longer work with full 2GiB RAM enabled in the device
> tree.

Did it work before these patches got applied initially?

> Could we work around this by having 1GiB of memory defined in the
> 32bit memory and then add the rest of the 3GiB from the >32bit
> area via LPAE? Will the kernel ever try to allocate DMA memory from
> anything >32bit?

You can solve the case for dma_alloc_coherent() this way, or by
setting the mask correctly. It won't help you for dma_map_* though,
which still requires someone to add support for swiotlb or using
an IOMMU if present.

	Arnd
