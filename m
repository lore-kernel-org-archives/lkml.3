Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbaDHNJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:09:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45390 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbaDHNJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:09:26 -0400
Date: Tue, 8 Apr 2014 14:09:20 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH v7 6/6] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140408130920.GY17163@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Hanjun Guo <hanjun.guo@linaro.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-7-git-send-email-Liviu.Dudau@arm.com>
 <5343F252.2050708@linaro.org>
MIME-Version: 1.0
In-Reply-To: <5343F252.2050708@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Apr 2014 13:09:36.0706 (UTC) FILETIME=[CABC2220:01CF532B]
X-MC-Unique: 114040814092308201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On Tue, Apr 08, 2014 at 01:57:54PM +0100, Hanjun Guo wrote:
> Hi Liviu,
> 
> On 2014-3-14 23:34, Liviu Dudau wrote:
> > Several platforms use a rather generic version of parsing
> > the device tree to find the host bridge ranges. Move the common code
> > into the generic PCI code and use it to create a pci_host_bridge
> > structure that can be used by arch code.
> > 
> > Based on early attempts by Andrew Murray to unify the code.
> > Used powerpc and microblaze PCI code as starting point.
> > 
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> > ---
> >  drivers/pci/host-bridge.c | 158 ++++++++++++++++++++++++++++++++++++
> >  include/linux/pci.h       |  13 +++
> >  2 files changed, 171 insertions(+)
> > 
> > diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> > index 8708b652..7cda90b 100644
> > --- a/drivers/pci/host-bridge.c
> > +++ b/drivers/pci/host-bridge.c
> > @@ -6,9 +6,14 @@
> >  #include <linux/init.h>
> >  #include <linux/pci.h>
> >  #include <linux/module.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_pci.h>
> > +#include <linux/slab.h>
> >  
> >  #include "pci.h"
> >  
> > +static atomic_t domain_nr = ATOMIC_INIT(-1);
> 
> domain_nr will only be used inside the #ifdef CONFIG_OF,
> and this will lead to compile warning which complains that
> 'domain_nr' defined but not used when CONFIG_OF=n (for example
> on x86).
> 
> How about moving the definition to --->
> 
> > +
> >  static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
> >  {
> >  	while (bus->parent)
> > @@ -92,3 +97,156 @@ void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
> >  	res->end = region->end + offset;
> >  }
> >  EXPORT_SYMBOL(pcibios_bus_to_resource);
> > +
> > +#ifdef CONFIG_OF
> 
> here?

I've already moved the definition there in my refresh.

Thanks for reviewing the code,
Liviu

> 
> Thanks
> Hanjun
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

