Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab3CWNhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 09:37:16 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41621 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3CWNhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 09:37:11 -0400
Date: Sat, 23 Mar 2013 14:37:04 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130323143704.5da5d20c@skate>
In-Reply-To: <20130323104156.GL4977@n2100.arm.linux.org.uk>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
	<20130323104156.GL4977@n2100.arm.linux.org.uk>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 23 Mar 2013 10:41:56 +0000, Russell King - ARM Linux wrote:

> Please look at how IORESOURCE_* stuff is defined:
> #define IORESOURCE_TYPE_BITS    0x00001f00      /* Resource type */
> #define IORESOURCE_IO           0x00000100      /* PCI/ISA I/O ports */
> #define IORESOURCE_MEM          0x00000200
> #define IORESOURCE_REG          0x00000300      /* Register offsets */
> #define IORESOURCE_IRQ          0x00000400
> #define IORESOURCE_DMA          0x00000800
> #define IORESOURCE_BUS          0x00001000
> 
> Notice that it's not an array of bits.
> 
> So this should be:
> 		if ((iter.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_IO) {

What I've done for the Marvell PCIe driver is:

+	for_each_of_pci_range(&iter, np) {
+		unsigned long restype = iter.flags & IORESOURCE_TYPE_BITS;
+		if (restype == IORESOURCE_IO) {
[...]
+		if (restype == IORESOURCE_MEM) {
[...]

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
