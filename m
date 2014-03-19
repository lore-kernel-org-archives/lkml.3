Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256AbaCSN4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:56:50 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:54047 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933380AbaCSN4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:56:47 -0400
Date: Wed, 19 Mar 2014 13:56:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Message-ID: <20140319135619.GC6231@localhost>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com>
 <20140314171457.GK18126@arm.com>
 <201403141838.08900.arnd@arndb.de>
 <20140314180527.GZ6457@e106497-lin.cambridge.arm.com>
 <20140317173821.GJ24070@arm.com>
 <20140317180525.GL6457@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317180525.GL6457@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 06:05:25PM +0000, Liviu Dudau wrote:
> On Mon, Mar 17, 2014 at 05:38:21PM +0000, Catalin Marinas wrote:
> > On Fri, Mar 14, 2014 at 06:05:27PM +0000, Liviu Dudau wrote:
> > > On Fri, Mar 14, 2014 at 05:38:08PM +0000, Arnd Bergmann wrote:
> > > > On Friday 14 March 2014, Catalin Marinas wrote:
> > > > > On Fri, Mar 14, 2014 at 03:34:18PM +0000, Liviu Dudau wrote:
> > > > > > --- /dev/null
> > > > > > +++ b/arch/arm64/kernel/pci.c
> > > > > [...]
> > > > > > +int pci_register_io_range(phys_addr_t address, resource_size_t size)
> > > > > [...]
> > > > > > +unsigned long pci_address_to_pio(phys_addr_t address)
> > > > > [...]
> > > > > > +void pcibios_fixup_bus(struct pci_bus *bus)
> > > > > [ actually most of this file ]
> > > > > 
> > > > > Maybe it was raised before already but can we have __weak generic
> > > > > definitions of these functions? They don't seem to be arm64 specific in
> > > > > any way.
> > [...]
> > > Catalin, if you are happy to ask for ACKs from all arch maintainers that might get
> > > affected by our custom version of pci_address_to_pio() before you can pull PCI support
> > > for arm64 then I can propose a new patchset.
> > 
> > You don't need to change the other architectures, that's the point of a
> > __weak definition, it will be automatically overridden. If you want, you
> > can even place a GENERIC_PCI or whatever config option that is only
> > selected by arm64 for the time being.
> 
> pci_address_to_pio() is alread __weak. My patch was adding the arm64 version of it. Adding
> an #ifdef GENERIC_PCI to the __weak implementation is not just a temporary solution.

Ah, I start to understand what you mean, pci_address_to_pio() is already
defined as __weak in drivers/of/address.c. So the reason we redefine it
on arm64 is that it uses the io_list resources which are populated by
pci_register_io_range(). Do you see any other architecture using a
similar logic (that could be shared)?

Any other functions in this file that could be shared (and are not
__weak already)?

-- 
Catalin
