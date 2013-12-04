Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab3LDRAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:00:44 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34287 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3LDRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:00:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo57gPPY73nCHbfGVynZRde0jj9_kjpR=FKwY-uTXzY2cw@mail.gmail.com>
References: <CAD6G_RT0S43BrOeXxJ6d3p1ALbXkGumZCSPBaK1Bz=2pX3hHYQ@mail.gmail.com>
	<CAErSpo4DNqUpA6Cb_tanW3uRJ3J-4utCQwtRz3eYZETCMtniUQ@mail.gmail.com>
	<CAD6G_RR=toq_6tCav6Y9=EprK9LC3YfGO=scvWpcGfDpWwJbRA@mail.gmail.com>
	<CAErSpo57gPPY73nCHbfGVynZRde0jj9_kjpR=FKwY-uTXzY2cw@mail.gmail.com>
Date: Wed, 4 Dec 2013 22:30:42 +0530
Message-ID: <CAD6G_RTHNGg7XSnDMQ-H+hUzmh1RPn9gYUDf7vRdeETmTmTdzw@mail.gmail.com>
Subject: Re: Need help on Linux PCIe
From: Jagan Teki <jagannadh.teki@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 8:41 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Dec 3, 2013 at 11:20 PM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
>> Thanks for your quick response.
>> Please find my comments below.
>>
>> On Tue, Dec 3, 2013 at 11:09 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> On Tue, Dec 3, 2013 at 4:24 AM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> I have few question on Linux PCIe subsystem, I am trying to understand
>>>> the PCIe on ARM platform.
>>>> 1. Compared to PCI, PCIe have an extra port functionalists/services
>>>> which is implemented drivers/pci/pcie/* is it true?
>>>
>>> Yes.
>>>
>>>> 2. PCIe root complex is same as Host controller drivers in linux drivers/host/*
>>>
>>> Yes.
>>>
>>>> 3. As individual endpoint drivers are registered to pci_core as
>>>> pci_driver_register, then what is the common call for registering
>>>> individual HC driver to pci-core?
>>>
>>> The host controller-PCI core interface is not as mature as the
>>> pci_register_driver() interface.  The basic interface is
>>> pci_scan_root_bus().  If you skim through the drivers in
>>> drivers/pci/host/* and drivers/acpi/pci_root.c, the interface to the
>>> PCI core will be fairly obvious.  And you'll learn what the existing
>>> practices are in case you need to add or modify something.
>>
>> OK.
>>
>> I understand the flow as below - please correct if am wrong.
>>
>> From low level (hw) - HC driver has a platform registration using
>> platform_driver_register() to lower layer
>> and then pci_scan_root_bus() --> pci_common_init_dev() registration to
>> upper layer as PCI - BIOS and then ends.
>
> Yes.  Sometime HC drivers use platform_driver_register(); other use
> something else depending on how the HC device is enumerated.  For
> example, drivers/acpi/pci_root.c uses something else to deal with host
> bridges in the ACPI namespace.
>
>> From upper level (app) - each endpoint driver has
>> pci_driver_register() call to PCI Core for lower level
>
> Yes.
>
>> and then the upper level registration is based on endpoint().
>
> I don't know what you mean here (I don't know of a function named
> "endpoint()").  But the driver model matches drivers to PCI functions
> based on vendor and device IDs.  A Linux "pci_dev" is what the PCI
> specs refer to as a "function."
Sorry it's typo - added ()

>
>> What is the connection here for PCI-BIOS and PCI-Core here, does these
>> are two different entities means there is no common call for these?
>> I see for ARM - "arch/arm/kernel/bios32.c" is PCI-BIOS is it correct?
>> does we have separate BIOS codes for architectures?
>
> The "pcibios_*" functions are architecture-specific things called by
> the generic PCI core.  Generally, things specified by the PCI specs
> are architecture-independent and should be in the PCI core
> (drivers/pci/*).

I have some good information to discuss from this thread.
Can you please verify this Linux PCIe subsystem stack - comment
whether my understanding is correct/not.
(I just draw this based on driver calls flow - to accommodate with in
the Linux cores)
http://jagannadhteki.blog.com/2013/12/04/linux-pcie-subsystem/

-- 
Thanks,
Jagan.
--------
Jagannadha Sutradharudu Teki,
E: jagannadh.teki@gmail.com, P: +91-9676773388
Engineer - System Software Hacker
U-boot - SPI Custodian and Zynq APSOC
Ln: http://www.linkedin.com/in/jaganteki
