Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbaGCJxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:53:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51810 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965074AbaGCJxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:53:06 -0400
Date: Thu, 3 Jul 2014 10:53:02 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        patches <patches@apm.com>
Subject: Re: [PATCH v8 2/9] pci: Export find_pci_host_bridge() function.
Message-ID: <20140703095302.GY2173@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-3-git-send-email-Liviu.Dudau@arm.com>
 <CACoXjck+aU33=kSy=KCGABNXNR7tj2KndAiBqEDK7wQ_Qei80Q@mail.gmail.com>
 <7101568.8DVJFku5jp@wuerfel>
 <CACoXjcn5wdOwQx6PSfhTyuo-FQqBL62o-MNj3i6EfENRnUNt6g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACoXjcn5wdOwQx6PSfhTyuo-FQqBL62o-MNj3i6EfENRnUNt6g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 03 Jul 2014 09:53:03.0913 (UTC) FILETIME=[95353990:01CF96A4]
X-MC-Unique: 114070310530307801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:43:41PM +0100, Tanmay Inamdar wrote:
> On Wed, Jul 2, 2014 at 12:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 02 July 2014 11:06:38 Tanmay Inamdar wrote:
> >> On Tue, Jul 1, 2014 at 11:43 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> >> > This is a useful function and we should make it visible outside the
> >> > generic PCI code. Export it as a GPL symbol.
> >> >
> >> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >> > Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> >> > ---
> >> >  drivers/pci/host-bridge.c | 3 ++-
> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> >> > index 0e5f3c9..36c669e 100644
> >> > --- a/drivers/pci/host-bridge.c
> >> > +++ b/drivers/pci/host-bridge.c
> >> > @@ -16,12 +16,13 @@ static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
> >> >         return bus;
> >> >  }
> >> >
> >> > -static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
> >> > +struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
> >> >  {
> >> >         struct pci_bus *root_bus = find_pci_root_bus(bus);
> >> >
> >> >         return to_pci_host_bridge(root_bus->bridge);
> >> >  }
> >> > +EXPORT_SYMBOL_GPL(find_pci_host_bridge);
> >>
> >> Is there any specific reason behind making this symbol GPL? I think
> >> the other functions in this file are just EXPORT_SYMBOL. Ultimately
> >> companies which have non gpl Linux modules (nvidia) will face issue
> >> using this API.
> >>
> >> The same applies to 'of_create_pci_host_bridge'.
> >
> > I think EXPORT_SYMBOL_GPL() is better here. The new symbols are unlikely
> > to be used by a peripheral device driver, and PCI host controllers are
> > already restricted by EXPORT_SYMBOL_GPL.
> >
> 
> You are right as long as the functions are not used directly. But what
> if GPL functions are called indirectly.  For example, 'pci_domain_nr'
> implementation in Liviu's V7 series calls 'find_pci_host_bridge'.

I will not be drawn into the discussion of EXPORT_SYMBOL vs EXPORT_SYMBOL_GPL()
other than to say that I don't understand what is so secret in implementing
a standard. I do not want to support host bridge drivers that are not open
source.

Best regards,
Liviu

> 
> > nvidia will certainly not do a PCI host controller driver that is not
> > upstream or not GPL-compatible.
> >
> >         Arnd
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

