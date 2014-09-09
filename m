Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaIIIrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:47:00 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38400 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbaIIIq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:46:28 -0400
Date: Tue, 9 Sep 2014 09:46:21 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Rob Herring <robherring2@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
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
Message-ID: <20140909084621.GS27864@e106497-lin.cambridge.arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-8-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com>
 <20140908145459.GO27864@e106497-lin.cambridge.arm.com>
 <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com>
 <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
 <540E960D.7080408@huawei.com>
MIME-Version: 1.0
In-Reply-To: <540E960D.7080408@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 09 Sep 2014 08:46:23.0015 (UTC) FILETIME=[8893A370:01CFCC0A]
X-MC-Unique: 114090909462404001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 06:54:21AM +0100, Yijing Wang wrote:
> >>> on new requests. This function gets called quite a lot and I'm trying not to
> >>> make it too heavy weight.
> >>
> >> Generally, nothing should be accessing the same DT value frequently.
> >> It should get cached somewhere.
> >>
> > 
> > The problem appears for DTs that don't have the pci-domain info. Then the cached
> > value is left at the default non-valid value and attempts to rescan the DT will
> > be made every time the function is called.
> > 
> >> I don't really understand how domains are used so it's hard to provide
> >> a recommendation here. Do domains even belong in the DT?
> > 
> > ACPI calls them segments and the way Bjorn explained it to me at some moment was
> > that it was an attempt to split up a bus in different groups (or alternatively,
> > merge a few busses together). To be honest I haven't seen systems where the domain
> > is anything other than zero, but JasonG (or maybe Benjamin) were floating an
> > idea of using the domain number to identify physical slots.
> 
> PCI domain(or named segment) is provided by firmware, in ACPI system, we evaluated it
> by method "_SEG". in IA64 with ACPI, PCI hostbridge driver retrieves the domain from ACPI,
> if it's absent, the default domain is zero. So I wonder why in DTS, if it's absent, we get
> a auto increment domain value.

Because you can have more than one hostbridge (rare, but not impossible) and unless you
want to join the two segments, you might want to give it a different domain.

Best regards,
Liviu

> 
> PCI get domain by ACPI "_SEG" in IA64(drivers/acpi/pci_root.c)
> ......
> 	status = acpi_evaluate_integer(handle, METHOD_NAME__SEG, NULL,
> 				       &segment);
> 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> 		dev_err(&device->dev,  "can't evaluate _SEG\n");
> 		result = -ENODEV;
> 		goto end;
> 	}
> .......
> 
> Thanks!
> Yijing.
> 
> > 
> >> This function
> >> is just a weird mixture of data retrieval and allocation. I think you
> >> need to separate it into 2 functions.
> > 
> > It is meant to do allocation with the retrieval being a short-cut (or fine
> > control if you want).
> > 
> > I need to think a bit more for a better solution.
> > 
> > Best regards,
> > Liviu
> > 
> >>
> >> Rob
> >>
> > 
> 
> 
> -- 
> Thanks!
> Yijing
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

