Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3LJCyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:54:08 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42714 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3LJCyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:54:06 -0500
Message-ID: <52A68220.30306@linaro.org>
Date: Tue, 10 Dec 2013 10:53:20 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running
 without PCI on ARM64
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <20131209115050.GA19163@arm.com> <52A5C024.5050702@linaro.org> <201312091735.05014.arnd@arndb.de> <20131209165548.GE19163@arm.com>
In-Reply-To: <20131209165548.GE19163@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-10 0:55, Catalin Marinas wrote:
> On Mon, Dec 09, 2013 at 04:35:04PM +0000, Arnd Bergmann wrote:
>> On Monday 09 December 2013, Hanjun Guo wrote:
>>> On 2013-12-9 19:50, Catalin Marinas wrote:
>>>> On Mon, Dec 09, 2013 at 04:12:24AM +0000, Hanjun Guo wrote:
>>>>>
>>>>> I think the concern here is that ACPI is only for server platform or not.
>>>>>
>>>>> Since ACPI has lots of content related to power management, I think ACPI
>>>>> can be used for mobile devices and other platform too, not only for ARM
>>>>> servers, and with this patch, we can support both requirement.
>>>>
>>>> 'Can be used' is one thing, will it really be used is another? I don't
>>>> think so, it was (well, is) difficult enough to make the transition to
>>>> FDT, I don't see how ACPI would solve the current issues.
>>
>> Exactly. In particular we don't want people to get the wrong idea about
>> where we are heading, so making it possible to use this code on embedded
>> systems for me is a reason *not* to take the patch.
> 
> I agree.
> 
>>>> I see ACPI as a server distro requirement and there are indeed benefits
>>>> in abstracting the hardware behind standard description, AML. Of course,
>>>> this would work even better with probe-able buses like PCIe and I'm
>>>> pretty sure this would be the case on high-end servers. But even if a
>>>> server distro like RHEL supports a SoC without PCIe, I would expect them
>>>> to only provide a single binary Image with CONFIG_PCI enabled.
>>>>
>>>> This patch is small enough and allows ACPI build with !CONFIG_PCI for
>>>> the time being but longer term I would expect such SoCs without PCI to
>>>> be able to run on a kernel with CONFIG_PCI enabled.
>>>
>>> Yes, we will support PCI in ACPI in the long run, and we just make PCI
>>> optional for ACPI in this patch.
>>
>> Do you mean there is a problem running your code with PCI /enabled/ at the
>> moment? If so, I'd suggest fixing that instead since you will have to fix
>> it anyway.
> 
> CONFIG_PCI does not exist on arm64 yet (we have some internal patches
> but may not be ready to be posted before the holidays; they try to share
> code with other archs, so more discussions before merging). We could add
> CONFIG_PCI and some dummy functions on arm64 for development (not to be
> upstreamed) or Hanjun could continue to use the current patch before we
> get PCI working. 

Thanks for the suggestion, I will continue to use the current patch, and
I will rework or rebase this one when PCI is working.

Hanjun

