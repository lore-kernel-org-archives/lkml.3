Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaDGOU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:20:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36064 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaDGOUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:20:54 -0400
Date: Mon, 7 Apr 2014 15:20:45 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 5/6] pci: Export find_pci_host_bridge() function.
Message-ID: <20140407142045.GO17163@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-6-git-send-email-Liviu.Dudau@arm.com>
 <20140404233948.GC15806@google.com>
MIME-Version: 1.0
In-Reply-To: <20140404233948.GC15806@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 07 Apr 2014 14:21:01.0929 (UTC) FILETIME=[9A838590:01CF526C]
X-MC-Unique: 114040715204805001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 12:39:48AM +0100, Bjorn Helgaas wrote:
> On Fri, Mar 14, 2014 at 03:34:31PM +0000, Liviu Dudau wrote:
> > This is a useful function and we should make it visible outside the
> > generic PCI code. Export it as a GPL symbol.
> > 
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> > ---
> >  drivers/pci/host-bridge.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> > index 06ace62..8708b652 100644
> > --- a/drivers/pci/host-bridge.c
> > +++ b/drivers/pci/host-bridge.c
> > @@ -17,12 +17,13 @@ static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
> >  	return bus;
> >  }
> >  
> > -static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
> > +struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
> >  {
> >  	struct pci_bus *root_bus = find_pci_root_bus(bus);
> >  
> >  	return to_pci_host_bridge(root_bus->bridge);
> >  }
> > +EXPORT_SYMBOL_GPL(find_pci_host_bridge);
> 
> Do you have a place where you actually need to use find_pci_host_bridge()?
> I'd rather not export it, even as _GPL, unless we have a user.

The code in arm64 series is using it to implement pci_domain_nr().

> 
> If we *do* export it, I'd like it to have a more conventional name, e.g.,
> something starting with "pci_".

Understood. pci_find_host_bridge() ?

Best regards,
Liviu

> 
> >  
> >  void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
> >  				 void (*release_fn)(struct pci_host_bridge *),
> > -- 
> > 1.9.0
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

