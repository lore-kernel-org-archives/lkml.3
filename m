Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbaGYPnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:43:08 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41179 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760814AbaGYPnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:43:03 -0400
Date: Fri, 25 Jul 2014 16:42:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
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
Subject: Re: [PATCH v8 6/9] pci: Introduce a domain number for
 pci_host_bridge.
Message-ID: <20140725154242.GN24268@arm.com>
References: <CAErSpo75ovmGoeSHKJN0nckGDy-0gpn8kLPfHQ79CtcXxhPydw@mail.gmail.com>
 <20140708224847.GC4980@e106497-lin.cambridge.arm.com>
 <CAErSpo5rBt0iF2HGeDD-UH6_sPCoC647VCw0Q1v_0Rdpvcir-w@mail.gmail.com>
 <20140710094758.GA6501@e106497-lin.cambridge.arm.com>
 <CAErSpo5ZNCY31NztT0cLFbRVsBZqMsZ0LbTFNOTQCZUU3F7qJA@mail.gmail.com>
 <20140711141115.GB16321@arm.com>
 <CAErSpo7C8qzmdp+XgVi2ysXj_NcgvVY7RVfBZ2PHimLzrzANMQ@mail.gmail.com>
 <20140711180151.GH16321@arm.com>
 <20140714163922.GH1112@arm.com>
 <CAErSpo65RBeTgzrVefWBfjnZqTPzyz__HnC4bn8riGGDC0GkHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo65RBeTgzrVefWBfjnZqTPzyz__HnC4bn8riGGDC0GkHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:15:58AM +0100, Bjorn Helgaas wrote:
> On Mon, Jul 14, 2014 at 10:39 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > From b32606aa3997fc8a45014a64f99e921eef4872b0 Mon Sep 17 00:00:00 2001
> > From: Catalin Marinas <catalin.marinas@arm.com>
> > Date: Mon, 14 Jul 2014 17:20:01 +0100
> > Subject: [PATCH] pci: Add support for generic domain_nr in pci_bus
> >
> > This patch adds domain_nr in struct pci_bus if
> > CONFIG_PCI_DOMAINS_GENERIC is enabled. The default implementation for
> > pci_domain_nr() simply returns bus->domain_nr. For the root bus, the
> > core PCI code calls pci_set_domain_nr(bus, parent_device) while the
> > child buses inherit the domain nr of the parent bus.
> >
> > This patch also adds an of_pci_set_domain_nr() implementation which
> > parses the device tree for the "pci-domain" property or sets domain_nr
> > to the next available value (this function could also be implemented
> > entirely in arm64).
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> I like this.  It seems like a reasonable step forward.  I don't really
> like the pci_set_domain_nr() interface because the domain conceptually
> exists before the root bus in the domain, but we can deal with that
> later.

That's just the name I came up with. Maybe something like
pci_assign_domain_to_bus()?

> I'd really like to see all this stuff in v3.17, but I'm going to be on
> vacation for the next three weeks and won't be able to do much until
> Aug 11, which is probably going to be in the middle of the merge
> window.  But maybe the series can be integrated in -next via an ARM
> tree or something.  If it helps, you can add my
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> for this piece.  I don't remember how many other PCI changes are
> involved; maybe my ack on this will be enough?  Even if we can't get
> it in for the merge window, I'm open to trying to merge it after
> v3.17-rc1 if it's isolated enough.

Thanks for the Ack but I think Liviu needs to address a few more things
with the OF part of his PCIe patches and it's unlikely that they are
ready for 3.17. My "deadline" is for 3.18 to get the generic (and arm64)
PCIe support in.

(I'm off for two weeks starting now as well).

-- 
Catalin
