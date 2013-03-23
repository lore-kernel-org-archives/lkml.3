Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3CWKmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 06:42:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42650 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3CWKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 06:42:43 -0400
Date: Sat, 23 Mar 2013 10:41:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
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
Message-ID: <20130323104156.GL4977@n2100.arm.linux.org.uk>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 01:04:53PM +0900, Jingoo Han wrote:
> -		switch ((pci_space >> 24) & 0x3) {
> -		case 1:		/* PCI IO space */
> +		if (iter.flags & IORESOURCE_IO) {

Please look at how IORESOURCE_* stuff is defined:
#define IORESOURCE_TYPE_BITS    0x00001f00      /* Resource type */
#define IORESOURCE_IO           0x00000100      /* PCI/ISA I/O ports */
#define IORESOURCE_MEM          0x00000200
#define IORESOURCE_REG          0x00000300      /* Register offsets */
#define IORESOURCE_IRQ          0x00000400
#define IORESOURCE_DMA          0x00000800
#define IORESOURCE_BUS          0x00001000

Notice that it's not an array of bits.

So this should be:
		if ((iter.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_IO) {

> +			iter.cpu_addr = iter.pci_addr;
> +		} else if (iter.flags & IORESOURCE_MEM) {

And this should be:
		} else if ((iter.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_MEM) {

> +		if (iter.flags & IORESOURCE_IO) {

Same here.

> +		} else if (iter.flags & IORESOURCE_MEM) {

And again here.

> -		switch ((pci_space >> 24) & 0x3) {
> -		case 1:		/* PCI IO space */
> +		if (iter.flags & IORESOURCE_IO) {

ditto.

> +			iter.cpu_addr = iter.pci_addr;
> +		} else if (flags & IORESOURCE_MEM) {

ditto.
