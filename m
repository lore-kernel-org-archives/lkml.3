Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaIJQ3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:29:07 -0400
Received: from [217.140.108.86] ([217.140.108.86]:60864 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751744AbaIJQ3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:29:01 -0400
Date: Tue, 9 Sep 2014 12:20:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robherring2@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
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
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI
 domain_nr
Message-ID: <20140909112054.GD29639@arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <540E960D.7080408@huawei.com>
 <20140909084621.GS27864@e106497-lin.cambridge.arm.com>
 <3780051.0eHpCN6UC9@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3780051.0eHpCN6UC9@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:16:04AM +0100, Arnd Bergmann wrote:
> On Tuesday 09 September 2014 09:46:21 Liviu Dudau wrote:
> > On Tue, Sep 09, 2014 at 06:54:21AM +0100, Yijing Wang wrote:
> > > >>> on new requests. This function gets called quite a lot and I'm trying not to
> > > >>> make it too heavy weight.
> > > >>
> > > >> Generally, nothing should be accessing the same DT value frequently.
> > > >> It should get cached somewhere.
> > > >>
> > > > 
> > > > The problem appears for DTs that don't have the pci-domain info. Then the cached
> > > > value is left at the default non-valid value and attempts to rescan the DT will
> > > > be made every time the function is called.
> > > > 
> > > >> I don't really understand how domains are used so it's hard to provide
> > > >> a recommendation here. Do domains even belong in the DT?
> > > > 
> > > > ACPI calls them segments and the way Bjorn explained it to me at some moment was
> > > > that it was an attempt to split up a bus in different groups (or alternatively,
> > > > merge a few busses together). To be honest I haven't seen systems where the domain
> > > > is anything other than zero, but JasonG (or maybe Benjamin) were floating an
> > > > idea of using the domain number to identify physical slots.
> > > 
> > > PCI domain(or named segment) is provided by firmware, in ACPI system, we evaluated it
> > > by method "_SEG". in IA64 with ACPI, PCI hostbridge driver retrieves the domain from ACPI,
> > > if it's absent, the default domain is zero. So I wonder why in DTS, if it's absent, we get
> > > a auto increment domain value.
> > 
> > Because you can have more than one hostbridge (rare, but not impossible) and unless you
> > want to join the two segments, you might want to give it a different domain.
> 
> I think you misunderstood the question. The difference is that in ACPI you
> are required to specify the domain, while in DT it is optional with your
> implementation.
> 
> I think in general it would be nice if we could mandate that in DT you also
> have to always provide a domain number, however the problem is that we can't
> change the existing DTB files that people are using that do not specify a
> domain.
> 
> We could possibly make this an architecture specific setting though and
> mandate that all ARM64 platforms have to set it, while ARM32 does not need
> it.

We can assume that if a domain is not specified and there is a single
top level PCIe node, the domain defaults to 0. Are there any arm32
platforms that require multiple domains (and do not specify a number in
the DT)?

-- 
Catalin
