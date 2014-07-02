Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaGBOXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:23:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40793 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaGBOXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:23:07 -0400
Date: Wed, 2 Jul 2014 15:23:03 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <liviu@dudau.co.uk>, Sinan Kaya <okaya@codeaurora.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140702142303.GJ2173@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <8556461.i7qCGvGY5a@wuerfel>
 <20140701204508.GA19569@bart.dudau.co.uk>
 <7343032.WUqPgbXNQS@wuerfel>
MIME-Version: 1.0
In-Reply-To: <7343032.WUqPgbXNQS@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 02 Jul 2014 14:23:04.0868 (UTC) FILETIME=[23510640:01CF9601]
X-MC-Unique: 114070215230410901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 01:30:31PM +0100, Arnd Bergmann wrote:
> On Tuesday 01 July 2014 21:45:09 Liviu Dudau wrote:
> > On Tue, Jul 01, 2014 at 09:36:10PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 01 July 2014 19:43:28 Liviu Dudau wrote:
> > > 
> > > This still conflicts with the other allocator you have in patch 9
> > > for pci_remap_iospace: nothing guarantees that the mapping is the
> > > same for both.
> > > 
> > > Also, this is a completely pointless exercise at this moment, because
> > > nobody cares about the result of pci_address_to_pio on architectures
> > > that don't already provide this function. If we ever get a proper
> > > Open Firmware implementation that wants to put hardcoded PCI devices
> > > into DT, we can add an implementation, but for now this seems overkill.
> > > 
> > > The allocator in pci_register_io_range seems reasonable, why not merge
> > > this function with pci_remap_iospace() as I have asked you multiple
> > > times before? Just make it return the io_offset so the caller can
> > > put that into the PCI host resources.
> > 
> > Hi Arnd,
> > 
> > While I agree with you that at some moment the allocators were inconsistent
> > wrt each other, for this version I would respectfully disagree on this.
> > The allocator in pci_register_io_range() only makes sure that the ranges
> > are not overlapping, it doesn't do any mapping whatsoever, while
> > pci_remap_iospace() does only an ioremap_page_range(). The idea is that
> > you get the offset out of pci_address_to_pio() and apply it to
> > pci_remap_iospace().
> 
> Ok, got it now, I'm sorry I didn't read this properly at first.
> 
> Your solution looks correct to me, just using different
> tradeoffs to what I was expecting: You get a working pci_address_to_pio()
> function, which is probably never needed, but in turn you need to
> keep the state of each host bridge in a global list.

Just a reminder that with my patchset I *do* start using pci_address_to_pio()
in order to correctly parse the IO ranges from DT.

Best regards,
Liviu

> 
> 	Arnd
> 
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

