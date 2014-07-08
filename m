Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaGHW6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:58:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45421 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGHW57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:57:59 -0400
Date: Tue, 8 Jul 2014 23:57:55 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
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
Subject: Re: [PATCH v8 8/9] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140708225755.GE4980@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-9-git-send-email-Liviu.Dudau@arm.com>
 <20140708010103.GD22939@google.com>
 <20140708102940.GZ6501@e106497-lin.cambridge.arm.com>
 <20140708213305.GB4555@google.com>
 <20140708222738.GA4980@e106497-lin.cambridge.arm.com>
 <20140708223737.GA19512@google.com>
MIME-Version: 1.0
In-Reply-To: <20140708223737.GA19512@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Jul 2014 22:57:56.0000 (UTC) FILETIME=[0E583200:01CF9B00]
X-MC-Unique: 114070823575605001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 11:37:37PM +0100, Bjorn Helgaas wrote:
> On Tue, Jul 08, 2014 at 11:27:38PM +0100, Liviu Dudau wrote:
> > On Tue, Jul 08, 2014 at 10:33:05PM +0100, Bjorn Helgaas wrote:
> > > On Tue, Jul 08, 2014 at 11:29:40AM +0100, Liviu Dudau wrote:
> > > > On Tue, Jul 08, 2014 at 02:01:04AM +0100, Bjorn Helgaas wrote:
> > > > > On Tue, Jul 01, 2014 at 07:43:33PM +0100, Liviu Dudau wrote:
> > > > > > ...
> > > > > > +int __weak pcibios_fixup_bridge_ranges(struct list_head *resources)
> > > > > > +{
> > > > > > +     return 0;
> > > > > > +}
> > > > > 
> > > > > I'd wait to add this until there's a platform that needs to implement it.
> > > > > Splitting it out will make this patch that much smaller and easier to
> > > > > understand.
> > > > 
> > > > I need this as this is the default implementation (i.e. do nothing). Otherwise the
> > > > link phase will give errors. 
> > > 
> > > I meant that you could remove the default implementation *and* the call of
> > > it, since it currently does nothing.
> > 
> > True. But it looks like converting Will's pci-host-generic.c driver will make use of this.
> 
> I think we should move this part of the patch to the conversion of
> that driver.  That will keep related changes grouped together, which 
> makes them easier to review and easier to backport, e.g., to distro
> kernels.
> 
> > > > > > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > > > > > index 7e7b939..556dc5f 100644
> > > > > > --- a/include/linux/pci.h
> > > > > > +++ b/include/linux/pci.h
> > > > > > @@ -402,6 +402,7 @@ struct pci_host_bridge {
> > > > > >       struct device dev;
> > > > > >       struct pci_bus *bus;            /* root bus */
> > > > > >       int domain_nr;
> > > > > > +     resource_size_t io_base;        /* physical address for the start of I/O area */
> > > > > 
> > > > > I don't see where this is used yet.
> > > > 
> > > > It's used in pci_host_bridge_of_get_ranges() (earlier in this patch).
> > > 
> > > of_create_pci_host_bridge() fills in bridge->io_base, but I don't see
> > > anything that ever *reads* bridge->io_base.
> > 
> > Ah, understood. It is used by the host bridge drivers to set their ATR registers to the
> > correct CPU address values.
> 
> Same applies here.

Except I have no idea which host bridge driver is going to be submitted first. There are
at least a couple of public series for HB drivers based on my series plus the one I have yet
to submit for my platform.

Maybe an associated documentation patch that explains the intended use for io_base could
persuade you on the value of keeping the io_base patch here?

Best regards,
Liviu

> 
> Bjorn
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

