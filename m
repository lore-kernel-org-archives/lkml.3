Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaIIF5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:57:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:34756 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbaIIF5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:57:20 -0400
Message-ID: <540E960D.7080408@huawei.com>
Date: Tue, 9 Sep 2014 13:54:21 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, Rob Herring <robherring2@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        "Rob Herring" <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Will Deacon" <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "Suravee Suthikulanit" <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Device Tree ML" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI
 domain_nr
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com> <1410184472-17630-8-git-send-email-Liviu.Dudau@arm.com> <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com> <20140908145459.GO27864@e106497-lin.cambridge.arm.com> <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com> <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> on new requests. This function gets called quite a lot and I'm trying not to
>>> make it too heavy weight.
>>
>> Generally, nothing should be accessing the same DT value frequently.
>> It should get cached somewhere.
>>
> 
> The problem appears for DTs that don't have the pci-domain info. Then the cached
> value is left at the default non-valid value and attempts to rescan the DT will
> be made every time the function is called.
> 
>> I don't really understand how domains are used so it's hard to provide
>> a recommendation here. Do domains even belong in the DT?
> 
> ACPI calls them segments and the way Bjorn explained it to me at some moment was
> that it was an attempt to split up a bus in different groups (or alternatively,
> merge a few busses together). To be honest I haven't seen systems where the domain
> is anything other than zero, but JasonG (or maybe Benjamin) were floating an
> idea of using the domain number to identify physical slots.

PCI domain(or named segment) is provided by firmware, in ACPI system, we evaluated it
by method "_SEG". in IA64 with ACPI, PCI hostbridge driver retrieves the domain from ACPI,
if it's absent, the default domain is zero. So I wonder why in DTS, if it's absent, we get
a auto increment domain value.

PCI get domain by ACPI "_SEG" in IA64(drivers/acpi/pci_root.c)
......
	status = acpi_evaluate_integer(handle, METHOD_NAME__SEG, NULL,
				       &segment);
	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
		dev_err(&device->dev,  "can't evaluate _SEG\n");
		result = -ENODEV;
		goto end;
	}
.......

Thanks!
Yijing.

> 
>> This function
>> is just a weird mixture of data retrieval and allocation. I think you
>> need to separate it into 2 functions.
> 
> It is meant to do allocation with the retrieval being a short-cut (or fine
> control if you want).
> 
> I need to think a bit more for a better solution.
> 
> Best regards,
> Liviu
> 
>>
>> Rob
>>
> 


-- 
Thanks!
Yijing

