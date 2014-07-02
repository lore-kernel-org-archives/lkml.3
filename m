Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaGBNUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:20:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51813 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaGBNUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:20:48 -0400
Date: Wed, 2 Jul 2014 14:20:42 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140702132042.GG2173@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-4-git-send-email-Liviu.Dudau@arm.com>
 <4751391.BGkeOrZGt8@wuerfel>
MIME-Version: 1.0
In-Reply-To: <4751391.BGkeOrZGt8@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 02 Jul 2014 13:20:43.0916 (UTC) FILETIME=[6D890CC0:01CF95F8]
X-MC-Unique: 114070214204600601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 01:38:04PM +0100, Arnd Bergmann wrote:
> Some more detailed comments now
> 
> On Tuesday 01 July 2014 19:43:28 Liviu Dudau wrote:
> > +/*
> > + * Record the PCI IO range (expressed as CPU physical address + size).
> > + * Return a negative value if an error has occured, zero otherwise
> > + */
> > +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> > +{
> > +#ifdef PCI_IOBASE
> > +       struct io_range *res;
> 
> I was confused by the variable naming here: A variable named 'res' is
> normally a 'struct resource'. Maybe better call this 'range'.
> 
> > +       resource_size_t allocated_size = 0;
> > +
> > +       /* check if the range hasn't been previously recorded */
> > +       list_for_each_entry(res, &io_range_list, list) {
> > +               if (addr >= res->start && addr + size <= res->start + size)
> > +                       return 0;
> > +               allocated_size += res->size;
> > +       }
> 
> A spin_lock around the list lookup should be sufficient to get around
> the race that Will mentioned.
> 
> > +       /* range not registed yet, check for available space */
> > +       if (allocated_size + size - 1 > IO_SPACE_LIMIT)
> > +               return -E2BIG;
> 
> It might be better to limit the size to 64K if it doesn't fit at first.

Thanks Arnd for review. Will update and post a new patch soon if I don't
get any other comments.

Best regards,
Liviu

> 
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

