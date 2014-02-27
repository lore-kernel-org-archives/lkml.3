Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaB0Ntg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:49:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:54031 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaB0Nte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:49:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/4] pci: Add support for creating a generic host_bridge from device tree
Date: Thu, 27 Feb 2014 14:48:44 +0100
Message-ID: <7910042.azG0y0Ppv9@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <18746655.qWHLpMg2Yy@wuerfel>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> <1393506402-11474-5-git-send-email-Liviu.Dudau@arm.com> <18746655.qWHLpMg2Yy@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gdP2nXMjBzerGj9ZPnMjx6PS8VcHqANwo0mV+BfNwIS
 XRpw/LmjpJrt0/de86E0SMGHVGp5wcQWLTNKKFTG8WQIr/q/xZ
 lPjRxon1L4aL82efcyaZdncvpwZ43Q94GC+nqFWkhYoEqkdSfo
 pYDqc2vURbqy60iKYjH9oNJXmjZpKqrGkN7rC7himHOPKV6i4U
 IzCU4MybPPXQM6Yl2nXWPVQTbnzI3EX0MKqzEjuUOlVQI56yAl
 8saS4iKG7sgQki0OLE68MbmkHmIDZSKVa1RWPDjFvu343s7auj
 JwDr0+hwf5wEh0yQOF+MiW+TbwonnkmbXxV6r0jspEGWlALiGj
 VJ82GJdjXQlxHddspV/g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 14:38:32 Arnd Bergmann wrote:
> > +     pr_debug("Parsing ranges property...\n");
> > +     for_each_of_pci_range(&parser, &range) {
> > +             /* Read next ranges element */
> > +             pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
> > +                             range.pci_space, range.pci_addr);
> > +             pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
> > +                                     range.cpu_addr, range.size);
> > +
> > +             /*
> > +              * If we failed translation or got a zero-sized region
> > +              * then skip this range
> > +              */
> > +             if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> > +                     continue;
> > +
> > +             res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> > +             if (!res) {
> > +                     err = -ENOMEM;
> > +                     goto bridge_ranges_nomem;
> > +             }
> > +
> > +             of_pci_range_to_resource(&range, dev, res);
> > +
> > +             if (resource_type(res) == IORESOURCE_IO)
> > +                     *io_base = range.cpu_addr;
> > +
> > +             pci_add_resource_offset(resources, res,
> > +                             res->start - range.pci_addr);
> > +     }
> 
> This is not the correct resource for I/O space at all. Please talk
> to Will, I've been over this with him in detail and he probably
> understands it now. I assume you are both working in the same
> building.
> 

Sorry, I initially missed part of your changes in patch 1.
I think it's actually correct now.

	Arnd
