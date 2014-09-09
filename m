Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaIIOSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:18:15 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:39855 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbaIIOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <3780051.0eHpCN6UC9@wuerfel>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <540E960D.7080408@huawei.com> <20140909084621.GS27864@e106497-lin.cambridge.arm.com>
 <3780051.0eHpCN6UC9@wuerfel>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 9 Sep 2014 08:17:50 -0600
Message-ID: <CAErSpo5ZyanUNiVnkt0q1m-HhMpTN+ZUVL59o70THyL_hKZAdg@mail.gmail.com>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI domain_nr
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 3:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 09 September 2014 09:46:21 Liviu Dudau wrote:
>> On Tue, Sep 09, 2014 at 06:54:21AM +0100, Yijing Wang wrote:
>> > PCI domain(or named segment) is provided by firmware, in ACPI system, we evaluated it
>> > by method "_SEG". in IA64 with ACPI, PCI hostbridge driver retrieves the domain from ACPI,
>> > if it's absent, the default domain is zero. So I wonder why in DTS, if it's absent, we get
>> > a auto increment domain value.
>>
>> Because you can have more than one hostbridge (rare, but not impossible) and unless you
>> want to join the two segments, you might want to give it a different domain.
>
> I think you misunderstood the question. The difference is that in ACPI you
> are required to specify the domain, while in DT it is optional with your
> implementation.

_SEG is actually optional, but the spec (ACPI r5.0, sec 6.5.6) says to
assume domain 0 if _SEG is absent.

Yijing mentioned ia64, which is relevant because PCI config accesses
on ia64 are done via a firmware (SAL) interface, and the domain is
part of that interface, so the kernel is actually required to supply
the correct domain number (0 or _SEG value) for each host bridge.

Bjorn
