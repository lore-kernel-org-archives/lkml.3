Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3CYKVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:21:55 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50470 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753081Ab3CYKVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:21:53 -0400
Date: Mon, 25 Mar 2013 10:21:06 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130325102106.GA20770@arm.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
 <20130323104156.GL4977@n2100.arm.linux.org.uk>
 <20130323143704.5da5d20c@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130323143704.5da5d20c@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 01:37:04PM +0000, Thomas Petazzoni wrote:
> 
> On Sat, 23 Mar 2013 10:41:56 +0000, Russell King - ARM Linux wrote:
> 
> > Please look at how IORESOURCE_* stuff is defined:
> > #define IORESOURCE_TYPE_BITS    0x00001f00      /* Resource type */
> > #define IORESOURCE_IO           0x00000100      /* PCI/ISA I/O ports */
> > #define IORESOURCE_MEM          0x00000200
> > #define IORESOURCE_REG          0x00000300      /* Register offsets */
> > #define IORESOURCE_IRQ          0x00000400
> > #define IORESOURCE_DMA          0x00000800
> > #define IORESOURCE_BUS          0x00001000
> > 
> > Notice that it's not an array of bits.
> > 
> > So this should be:
> > 		if ((iter.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_IO) {
> 
> What I've done for the Marvell PCIe driver is:
> 
> +	for_each_of_pci_range(&iter, np) {
> +		unsigned long restype = iter.flags & IORESOURCE_TYPE_BITS;
> +		if (restype == IORESOURCE_IO) {
> [...]
> +		if (restype == IORESOURCE_MEM) {
> [...]

OK I'll update this patch and also include Thierry's suggestions.

Andrew Murray
