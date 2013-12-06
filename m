Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3LFPFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:05:54 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:61435 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3LFPFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:05:52 -0500
Message-ID: <52A1E794.1040008@linaro.org>
Date: Fri, 06 Dec 2013 16:04:52 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Mark Rutland <mark.rutland@arm.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linaro-kernel@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, patches@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running
 without PCI on ARM64
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <20131203164111.GA13447@srcf.ucam.org> <529F376F.8050005@linaro.org> <201312052304.22302.arnd@arndb.de>
In-Reply-To: <201312052304.22302.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2013 23:04, Arnd Bergmann wrote:
> On Wednesday 04 December 2013, Hanjun Guo wrote:
>> On 2013年12月04日 00:41, Matthew Garrett wrote:
>>> Given the number of #ifdefs you're adding, wouldn't it make more sense
>>> to just add stub functions to include/linux/pci.h?
>>
>> Thanks for the suggestion :)
>>
>> I can add stub functions in include/linux/pci.h for raw_pci_read()/
>> raw_pci_write(), then can remove #ifdefs for acpi_os_read/write_pci_configuration().
>
> Actually I wonder about the usefulness of this patch in either form: Since ACPI
> on ARM64 is only for servers, I would very much expect them to always come with
> PCI, either physical host bridges with attached devices, or logical PCI functions
> used to describe the on-SoC I/O devices. Even in case of virtual machines, you'd
> normally use PCI as the method to communicate data about the virtio channels.
>
> Can you name a realistic use-case where you'd want ACPI but not PCI?

Yes you can describe SoC I/O devices using logical PCI functions only if 
they are on PCI, correct me if I am wrong. Also, devices can be placed 
only on IOMEM (like for ARM SoC) and it is hard to predict which way 
vendors chose. So way don't let it be configurable? ACPI spec says 
nothing like PCI is needed for ACPI, AFAIK.

Tomasz
