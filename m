Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbaCQRi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:38:56 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:58204 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933027AbaCQRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:38:52 -0400
Date: Mon, 17 Mar 2014 17:38:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Message-ID: <20140317173821.GJ24070@arm.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com>
 <20140314171457.GK18126@arm.com>
 <201403141838.08900.arnd@arndb.de>
 <20140314180527.GZ6457@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314180527.GZ6457@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 06:05:27PM +0000, Liviu Dudau wrote:
> On Fri, Mar 14, 2014 at 05:38:08PM +0000, Arnd Bergmann wrote:
> > On Friday 14 March 2014, Catalin Marinas wrote:
> > > On Fri, Mar 14, 2014 at 03:34:18PM +0000, Liviu Dudau wrote:
> > > > --- /dev/null
> > > > +++ b/arch/arm64/kernel/pci.c
> > > [...]
> > > > +int pci_register_io_range(phys_addr_t address, resource_size_t size)
> > > [...]
> > > > +unsigned long pci_address_to_pio(phys_addr_t address)
> > > [...]
> > > > +void pcibios_fixup_bus(struct pci_bus *bus)
> > > [ actually most of this file ]
> > > 
> > > Maybe it was raised before already but can we have __weak generic
> > > definitions of these functions? They don't seem to be arm64 specific in
> > > any way.
[...]
> Catalin, if you are happy to ask for ACKs from all arch maintainers that might get
> affected by our custom version of pci_address_to_pio() before you can pull PCI support
> for arm64 then I can propose a new patchset.

You don't need to change the other architectures, that's the point of a
__weak definition, it will be automatically overridden. If you want, you
can even place a GENERIC_PCI or whatever config option that is only
selected by arm64 for the time being.

-- 
Catalin
