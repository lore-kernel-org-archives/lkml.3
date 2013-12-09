Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983Ab3LIXey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:34:54 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:45364 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3LIXeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:34:50 -0500
MIME-Version: 1.0
In-Reply-To: <201312052304.22302.arnd@arndb.de>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
	<20131203164111.GA13447@srcf.ucam.org>
	<529F376F.8050005@linaro.org>
	<201312052304.22302.arnd@arndb.de>
Date: Mon, 9 Dec 2013 17:34:49 -0600
Message-ID: <CAL_JsqKKKh7d61hJuSc8mGMCmeYB1hshHGS5ML4eRXWHmjZrgA@mail.gmail.com>
Subject: Re: [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI on ARM64
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>, Linaro Patches <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Hanjun Guo <hanjun.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Jon Masters <jonathan@jonmasters.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 4:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 04 December 2013, Hanjun Guo wrote:
>> On 2013年12月04日 00:41, Matthew Garrett wrote:
>> > Given the number of #ifdefs you're adding, wouldn't it make more sense
>> > to just add stub functions to include/linux/pci.h?
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

Calxeda h/w. Yes, we do have PCI, but it is optional.

Rob
