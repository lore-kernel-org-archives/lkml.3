Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567Ab3LIENJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:13:09 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46617 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549Ab3LIENF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:13:05 -0500
Message-ID: <52A54328.3000709@linaro.org>
Date: Mon, 09 Dec 2013 12:12:24 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Tomasz Nowicki <tomasz.nowicki@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linaro-kernel@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, patches@linaro.org,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running
 without PCI on ARM64
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <201312052304.22302.arnd@arndb.de> <52A1E794.1040008@linaro.org> <201312061823.26481.arnd@arndb.de>
In-Reply-To: <201312061823.26481.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-7 1:23, Arnd Bergmann wrote:
> On Friday 06 December 2013, Tomasz Nowicki wrote:
>> On 05.12.2013 23:04, Arnd Bergmann wrote:
>>> On Wednesday 04 December 2013, Hanjun Guo wrote:
>>>> On 2013年12月04日 00:41, Matthew Garrett wrote:
>>>>> Given the number of #ifdefs you're adding, wouldn't it make more sense
>>>>> to just add stub functions to include/linux/pci.h?
>>>>
>>>> Thanks for the suggestion :)
>>>>
>>>> I can add stub functions in include/linux/pci.h for raw_pci_read()/
>>>> raw_pci_write(), then can remove #ifdefs for acpi_os_read/write_pci_configuration().
>>>
>>> Actually I wonder about the usefulness of this patch in either form: Since ACPI
>>> on ARM64 is only for servers, I would very much expect them to always come with
>>> PCI, either physical host bridges with attached devices, or logical PCI functions
>>> used to describe the on-SoC I/O devices. Even in case of virtual machines, you'd
>>> normally use PCI as the method to communicate data about the virtio channels.
>>>
>>> Can you name a realistic use-case where you'd want ACPI but not PCI?
>>
>> Yes you can describe SoC I/O devices using logical PCI functions only if 
>> they are on PCI, correct me if I am wrong. Also, devices can be placed 
>> only on IOMEM (like for ARM SoC) and it is hard to predict which way 
>> vendors chose. So way don't let it be configurable? ACPI spec says 
>> nothing like PCI is needed for ACPI, AFAIK.
> 
> You are right that today's ARM SoCs basically never use PCI to describe
> internal devices (IIRC VIA VT8500 is an exception, but their PCI was
> just a software fabrication).
> 
> However, when we're talking about ACPI on ARM64, that is nothing like classic
> ARM SoCs: As Jon Masters mentioned, this is about new server hardware following
> a (still secret, but hopefully not much longer) hardware specification that is
> explicitly designed to allow interoperability between vendors, so they
> must have put some thought into how to make the hardware discoverable. It
> seems that they are modeling things after how it's done on x86, and the
> only sensible way to have discoverable hardware there is PCI. This is
> also what all x86 SoCs do.

I think the concern here is that ACPI is only for server platform or not.

Since ACPI has lots of content related to power management, I think ACPI
can be used for mobile devices and other platform too, not only for ARM
servers, and with this patch, we can support both requirement.

Thanks
Hanjun
