Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaIWKtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:49:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45008 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaIWKtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:49:22 -0400
Date: Tue, 23 Sep 2014 11:49:18 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tanmay Inamdar <tinamdar@apm.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@codeaurora.org>,
        Sunil Goutham <sunil.goutham@caviumnetworks.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v11 08/10] OF: PCI: Add support for parsing PCI host
 bridge resources from DT
Message-ID: <20140923104918.GP1994@e106497-lin.cambridge.arm.com>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
 <20140922093228.GA20256@rric.localhost>
 <20140922114317.GN1994@e106497-lin.cambridge.arm.com>
 <8687285.EH4RPBeOB5@wuerfel>
MIME-Version: 1.0
In-Reply-To: <8687285.EH4RPBeOB5@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 23 Sep 2014 10:49:19.0747 (UTC) FILETIME=[073C1D30:01CFD71C]
X-MC-Unique: 114092311492011901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 08:56:37AM +0100, Arnd Bergmann wrote:
> On Monday 22 September 2014 12:43:17 Liviu Dudau wrote:
> > > 
> > > From e798af4fc2f664d1aff7e863489b8298f90e716e Mon Sep 17 00:00:00 2001
> > > From: Robert Richter <rrichter@cavium.com>
> > > Date: Mon, 22 Sep 2014 10:46:01 +0200
> > > Subject: [PATCH] OF: PCI: Fix creation of mem-mapped pci host bridges
> > > 
> > > The pci host bridge was not created if io_base was not set when
> > > calling of_pci_get_host_bridge_resources(). This is esp. the case for
> > > mem-mapped io (IORESOURCE_MEM). This patch fixes this. Function
> > > parameter io_base is optional now.
> > 
> > I think the message is misleading. What you want to do is make io_base
> > optional for the case where the PCI host bridge only expects to have only
> > IORESOURCE_MEM ranges and doesn't care about IORESOURCE_IO ones.
> > 
> > As I'm going to touch this area again to address a comment from Bjorn,
> > do you mind if I roll this patch into mine with your Signed-off-by and
> > the mention that you have made io_base optional?
> 
> I think the best way to deal with this is to move the check for 
> io_base down into the place where it is used: As long as the DT only
> specifies IORESOURCE_MEM windows, we don't need to look at io_base,
> but if the host controller driver does not support IORESOURCE_IO
> while the DT specifies it, I guess it would be nice to return an
> error.

Because the detection of IORESOURCE_{IO|MEM} happens in a loop I still
need to initialise the io_base to some invalid value before going into the
for_each_of_pci_range() {...} body. I have added a check in v12 for the
lack of valid io_base pointer if IORESOURCE_IO range is found.

Best regards,
Liviu

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

