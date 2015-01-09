Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbbAIAF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:05:28 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:63359 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbbAIAF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:05:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Rob Herring <robherring2@gmail.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 2/4] of: move of_dma_configure() to device,c to help re-use
Date: Fri, 09 Jan 2015 01:05:11 +0100
Message-ID: <2405706.Bhe0GramZJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54AF165F.7070909@ti.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <2083932.v1GzgAfexK@wuerfel> <54AF165F.7070909@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:1HQCtwJiGu6yOKbteQBVzeGf+LzEER6Ddlycn/NvGtWtW12TKX+
 ctlhKpdBwCwKNmHilU9qZtLSfKCWqZK6XnYBBlwafwqXAcacu8/myKGzVXCI/ZIhM9zklLz
 Y28pYzFJ5B0drT0bNNk/z95lXw6kSOYZdJdqFxOZxiYMaLkEut9eXyJ9DAacpUP/W361uTF
 QgZf2OF8Mw+geh+Dz2w1A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2015 18:44:31 Murali Karicheri wrote:
> The grep of dma-ranges for arch/arm shows the size used is mask + 1 as
> 
> ./boot/dts/keystone.dtsi:               dma-ranges = <0x80000000 0x8 0x00000000 
> 0x80000000>;
> ./boot/dts/keystone.dtsi:                       dma-ranges;
> ./boot/dts/keystone.dtsi:                       dma-ranges;
> ./boot/dts/r8a7790.dtsi:                dma-ranges = <0x42000000 0 0x40000000 0 
> 0x40000000 0 0x80000000
> ./boot/dts/integratorap.dts:    dma-ranges = <0x80000000 0x0 0x80000000>;
> ./boot/dts/r8a7791.dtsi:                dma-ranges = <0x42000000 0 0x40000000 0 
> 0x40000000 0 0x80000000
> ./boot/dts/.k2hk-evm.dtb.dts.tmp:  dma-ranges = <0x80000000 0x8 
> 0x00000000 0x80000000>;
> ./boot/dts/.k2hk-evm.dtb.dts.tmp:   dma-ranges;
> ./boot/dts/.k2l-evm.dtb.dts.tmp:  dma-ranges = <0x80000000 0x8 
> 0x00000000 0x80000000>;
> ./boot/dts/.k2l-evm.dtb.dts.tmp:   dma-ranges;
> ./boot/dts/.k2e-evm.dtb.dts.tmp:  dma-ranges = <0x80000000 0x8 
> 0x00000000 0x80000000>;
> ./boot/dts/.k2e-evm.dtb.dts.tmp:   dma-ranges;
> ./boot/dts/.k2e-evm.dtb.dts.tmp:   dma-ranges;
> ./boot/dts/k2e.dtsi:                    dma-ranges;
> ./boot/dts/k2e.dtsi:                    dma-ranges;
> 
> So for ARM 32 the below case doesn't seem to apply.
> 

Ah, I guess that is because an empty dma-ranges property serves the same
purpose.

	Arnd
