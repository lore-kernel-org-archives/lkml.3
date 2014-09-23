Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaIWNac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:30:32 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60599 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaIWNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <8687285.EH4RPBeOB5@wuerfel>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
 <20140922093228.GA20256@rric.localhost> <20140922114317.GN1994@e106497-lin.cambridge.arm.com>
 <8687285.EH4RPBeOB5@wuerfel>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 23 Sep 2014 08:30:08 -0500
Message-ID: <CAL_JsqK3yH-uf++haBovWdX6er1PtzeiZ-2-yT1TRfYPxAjFow@mail.gmail.com>
Subject: Re: [PATCH v11 08/10] OF: PCI: Add support for parsing PCI host
 bridge resources from DT
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Robert Richter <rric@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 2:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 22 September 2014 12:43:17 Liviu Dudau wrote:
>> >
>> > From e798af4fc2f664d1aff7e863489b8298f90e716e Mon Sep 17 00:00:00 2001
>> > From: Robert Richter <rrichter@cavium.com>
>> > Date: Mon, 22 Sep 2014 10:46:01 +0200
>> > Subject: [PATCH] OF: PCI: Fix creation of mem-mapped pci host bridges
>> >
>> > The pci host bridge was not created if io_base was not set when
>> > calling of_pci_get_host_bridge_resources(). This is esp. the case for
>> > mem-mapped io (IORESOURCE_MEM). This patch fixes this. Function
>> > parameter io_base is optional now.
>>
>> I think the message is misleading. What you want to do is make io_base
>> optional for the case where the PCI host bridge only expects to have only
>> IORESOURCE_MEM ranges and doesn't care about IORESOURCE_IO ones.
>>
>> As I'm going to touch this area again to address a comment from Bjorn,
>> do you mind if I roll this patch into mine with your Signed-off-by and
>> the mention that you have made io_base optional?
>
> I think the best way to deal with this is to move the check for
> io_base down into the place where it is used: As long as the DT only
> specifies IORESOURCE_MEM windows, we don't need to look at io_base,
> but if the host controller driver does not support IORESOURCE_IO
> while the DT specifies it, I guess it would be nice to return an
> error.

The DT may specify it, but the h/w could be broken in some way so the
host driver chooses to ignore it. I don't think we should force the
host driver to provide a pointer in that case. Also, would we want it
added to the resource list if it is not going to be used?

Rob
