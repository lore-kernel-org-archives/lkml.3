Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaIXJVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:21:03 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:44575 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaIXJUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:20:42 -0400
Date: Wed, 24 Sep 2014 11:20:36 +0200
From: Robert Richter <rric@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liviu Dudau <liviu@dudau.co.uk>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
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
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Andrew Murray <amurray@embedded-bits.co.uk>
Subject: Re: [PATCH v12 05/12] PCI: OF: Fix the conversion of IO ranges into
 IO resources.
Message-ID: <20140924092036.GC20256@rric.localhost>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-6-git-send-email-Liviu.Dudau@arm.com>
 <20140924002253.GB27357@google.com>
 <20140924011249.GC32643@bart.dudau.co.uk>
 <CAErSpo5GiycLfcx68tocfrGFt67+OPKLVZB1zdsZFU2M6gC_ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5GiycLfcx68tocfrGFt67+OPKLVZB1zdsZFU2M6gC_ag@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.09.14 19:16:19, Bjorn Helgaas wrote:
> You probably saw the subsequent [pci:pci/host-generic 10/13]
> drivers/of/of_pci.c:202:3: error: implicit declaration of function
> 'of_pci_range_to_resource' error.
> 
> I looked at that a bit, but gave up.  Apparently drivers/of/of_pci.c
> can be compiled with CONFIG_PCI=y but CONFIG_OF_ADDRESS not set..

This is due to the !SPARC dependency in drivers/of/Kconfig:

config OF_ADDRESS
        def_bool y
        depends on !SPARC
        select OF_ADDRESS_PCI if PCI

Error above occurs with ARCH=sparc.

-Robert
