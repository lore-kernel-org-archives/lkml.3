Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaIJCBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:01:36 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:10079 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaIJCBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:01:34 -0400
Message-ID: <540FAFA4.1080008@huawei.com>
Date: Wed, 10 Sep 2014 09:55:48 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Liviu Dudau <Liviu.Dudau@arm.com>, Rob Herring <robherring2@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
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
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com> <1410184472-17630-8-git-send-email-Liviu.Dudau@arm.com> <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com> <20140908145459.GO27864@e106497-lin.cambridge.arm.com> <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com> <20140908155931.GP27864@e106497-lin.cambridge.arm.com> <540E960D.7080408@huawei.com> <20140909084621.GS27864@e106497-lin.cambridge.arm.com> <540EC8CB.7010106@huawei.com> <CAErSpo4cAfom2=07NYDRfTCdHO22M0v+ueiaZuG6v2Xd18wEnQ@mail.gmail.com>
In-Reply-To: <CAErSpo4cAfom2=07NYDRfTCdHO22M0v+ueiaZuG6v2Xd18wEnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.540FAFB2.007F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 00588597c07062a49489c0bbfbc5ea0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> OK. Sorry, I have one last question, because domain will be used to calculate the address used to
>> access PCI hardware config registers. So if DTS file doesn't report the domain, how do we know
>> we would access the right registers when we use the auto increment domain vaule ?
>> Has there a mechanism to make sure system can access the correct registers by the domain ?
> 
> I think you're referring to config access via ECAM (PCIe r3.0, sec
> 7.2.2).  In that case, I don't think the domain should be used to
> compute the memory-mapped configuration address.  Each host bridge is
> in exactly one domain, and each host bridge has an associated ECAM
> area base.  The address calculation uses the bus number, device
> number, function number, and register number to compute an offset into
> the ECAM area.
> 
> So as long as the DT tells you the ECAM information for each host
> bridge, that should be sufficient.  The domain number is then just a
> Linux convenience and is not tied to the platform as it is on ia64.

Hi Bjorn, you are right, thanks for your detailed explanation! :)

Thanks!
Yijing.

> 
> Bjorn
> 
> .
> 


-- 
Thanks!
Yijing

