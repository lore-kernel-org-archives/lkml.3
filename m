Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaCNSFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:05:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49283 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbaCNSFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:05:32 -0400
Date: Fri, 14 Mar 2014 18:05:27 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Message-ID: <20140314180527.GZ6457@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com>
 <20140314171457.GK18126@arm.com>
 <201403141838.08900.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201403141838.08900.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 14 Mar 2014 18:05:38.0987 (UTC) FILETIME=[018D5FB0:01CF3FB0]
X-MC-Unique: 114031418053005501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 05:38:08PM +0000, Arnd Bergmann wrote:
> On Friday 14 March 2014, Catalin Marinas wrote:
> > On Fri, Mar 14, 2014 at 03:34:18PM +0000, Liviu Dudau wrote:
> > > --- /dev/null
> > > +++ b/arch/arm64/kernel/pci.c
> > [...]
> > > +int pci_register_io_range(phys_addr_t address, resource_size_t size)
> > [...]
> > > +unsigned long pci_address_to_pio(phys_addr_t address)
> > [...]
> > > +void pcibios_fixup_bus(struct pci_bus *bus)
> > [ actually most of this file ]
> > 
> > Maybe it was raised before already but can we have __weak generic
> > definitions of these functions? They don't seem to be arm64 specific in
> > any way.
> > 
> 
> I would definitely prefer that.
> 
> 	Arnd
> 

I haven't seen any reaction from Bjorn on this, so I threaded carefully on that
subject. I'm new to this so I don't know how to handle this.

To my mind, and looking at the way every architecture has been setup, the pcibios_*
function are intended to be provided by the architecture. No matter how much wishful
thinking we are going to put in here, it will not change the fact that the non-arm64
specific version of pcibios_fixup_bus() that I wrote is not shared by anyone else
and it will remain "for arm64 use only" regardless to where it is placed until the
next architecture comes into the kernel. And even then its adoption is questionable.
If we are looking for simple and common implementations of this function, maybe we
should look at why microblaze and powerpc versions, that are identical, are not being
made the default __weak implementation.

As for the other two functions, I've no special attachment to where they are present
and I'm happy to move them into drivers/pci on the condition that the patchset doesn't
double in size. The reason why I'm weary of touching other architectures in a significant
way is the current lack of engineering bandwidth and way of testing all the architectures.
My low friction approach has been to introduce them in arm64 and then slowly move them
into core (and yes, I know about good intentions and the road to hell.)

Catalin, if you are happy to ask for ACKs from all arch maintainers that might get
affected by our custom version of pci_address_to_pio() before you can pull PCI support
for arm64 then I can propose a new patchset.

Best regards,
Liviu 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

