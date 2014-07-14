Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbaGNQ5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:57:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34870 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbaGNQ45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:56:57 -0400
Date: Mon, 14 Jul 2014 17:56:53 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 9/9] pci: Remap I/O bus resources into CPU space with
 pci_remap_iospace()
Message-ID: <20140714165653.GD825@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-10-git-send-email-Liviu.Dudau@arm.com>
 <20140714165443.GI1112@arm.com>
MIME-Version: 1.0
In-Reply-To: <20140714165443.GI1112@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 14 Jul 2014 16:56:54.0392 (UTC) FILETIME=[9D7F9F80:01CF9F84]
X-MC-Unique: 114071417565500901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 05:54:43PM +0100, Catalin Marinas wrote:
> On Tue, Jul 01, 2014 at 07:43:34PM +0100, Liviu Dudau wrote:
> > Introduce a default implementation for remapping PCI bus I/O resources
> > onto the CPU address space. Architectures with special needs may
> > provide their own version, but most should be able to use this one.
> [...]
> > +/**
> > + *	pci_remap_iospace - Remap the memory mapped I/O space
> > + *	@res: Resource describing the I/O space
> > + *	@phys_addr: physical address where the range will be mapped.
> > + *
> > + *	Remap the memory mapped I/O space described by the @res
> > + *	into the CPU physical address space. Only architectures
> > + *	that have memory mapped IO defined (and hence PCI_IOBASE)
> > + *	should call this function.
> > + */
> > +int __weak pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr)
> > +{
> > +	int err = -ENODEV;
> > +
> > +#ifdef PCI_IOBASE
> > +	if (!(res->flags & IORESOURCE_IO))
> > +		return -EINVAL;
> > +
> > +	if (res->end > IO_SPACE_LIMIT)
> > +		return -EINVAL;
> > +
> > +	err = ioremap_page_range(res->start + (unsigned long)PCI_IOBASE,
> > +				res->end + 1 + (unsigned long)PCI_IOBASE,
> > +				phys_addr, __pgprot(PROT_DEVICE_nGnRE));
> 
> Except that PROT_DEVICE_nGnRE is arm64 only. I think that's a function
> that should remain arch specific.

Yes, I was following Arnd's suggestion and lost track of the fact that
PROT_DEVICE_nGnRE is arm64 specific.

Best regards,
Liviu

> 
> -- 
> Catalin

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

