Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaIVP35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:29:57 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61865 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaIVP3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:29:53 -0400
Date: Mon, 22 Sep 2014 17:29:48 +0200
From: Robert Richter <rric@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v11 10/10] PCI: Introduce pci_remap_iospace() for
 remapping PCI I/O bus resources into CPU space
Message-ID: <20140922152948.GB20256@rric.localhost>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
 <1411003825-21521-11-git-send-email-Liviu.Dudau@arm.com>
 <20140919215400.GA30239@google.com>
 <201409200420.31433.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201409200420.31433.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.09.14 04:20:31, Arnd Bergmann wrote:
> On Friday 19 September 2014, Bjorn Helgaas wrote:
> > On Thu, Sep 18, 2014 at 02:30:25AM +0100, Liviu Dudau wrote:
> 
> > PCI_IOBASE is a virtual address.  So PCI_IOBASE + res->start is also a
> > virtual address (only for IORESOURCE_IO).
> > 
> > Since res->start is normally a *physical* address, I think it would be less
> > confusing to do something like this:
> > 
> >     vaddr = PCI_IOBASE + res->start;
> >     ioremap_page_range(vaddr, vaddr + resource_size(res), ...);
> > 
> > so we have a hint that the first two ioremap_page_range() parameters are
> > virtual addresses.  It's also confusing that it uses "unsigned long" for
> > the virtual addresses, when we usually use "void *".  But that's out of
> > scope for this patch.
> 
> Good idea. I think it will have to be (unsigned long)PCI_IOBASE above then,
> since ioremap_page_range takes a 'unsigned long' virtual address and PCI_IOBASE
> should really remain an __iomem pointer.

Right, I see this warning here:

drivers/pci/pci.c: In function ‘pci_remap_iospace’:
drivers/pci/pci.c:2728:8: warning: assignment makes integer from pointer without a cast [enabled by default]

-Robert
