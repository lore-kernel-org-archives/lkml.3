Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaIHOFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:05:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44725 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaIHOFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:05:40 -0400
Date: Mon, 8 Sep 2014 15:05:34 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
Subject: Re: [PATCH v10 06/10] PCI: Introduce generic domain handling for PCI
 busses.
Message-ID: <20140908140533.GM27864@e106497-lin.cambridge.arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-7-git-send-email-Liviu.Dudau@arm.com>
 <20140908140321.GF22717@arm.com>
MIME-Version: 1.0
In-Reply-To: <20140908140321.GF22717@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Sep 2014 14:05:35.0239 (UTC) FILETIME=[F5C75970:01CFCB6D]
X-MC-Unique: 114090815053708201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 03:03:21PM +0100, Catalin Marinas wrote:
> On Mon, Sep 08, 2014 at 02:54:28PM +0100, Liviu Dudau wrote:
> > The handling of PCI domains (or PCI segments in ACPI speak) is
> > usually a straightforward affair but its implementation is
> > currently left to the architectural code, with pci_domain_nr(b)
> > querying the value of the domain associated with bus b.
> > 
> > This patch introduces CONFIG_PCI_DOMAINS_GENERIC as an
> > option that can be selected if an architecture want a
> > simple implementation where the value of the domain
> > associated with a bus is stored in struct pci_bus.
> > 
> > The architectures that select CONFIG_PCI_DOMAINS_GENERIC will
> > then have to implement pci_bus_assign_domain_nr() as a way
> > of setting the domain number associated with a root bus.
> > All child busses except the root bus will inherit the domain_nr
> > value from their parent.
> > 
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Catalin Marinas <Catalin.Marinas@arm.com>
> > [Renamed pci_set_domain_nr() to pci_bus_assign_domain_nr()]
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> I'm probably the author here, but the patch log doesn't say so (I don't
> mind, just a remark).

I've took you patch initially from an email fragment, sorry, should've
altered the commiter accordingly.

Best regards,
Liviu

> 
> -- 
> Catalin

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

