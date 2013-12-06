Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161032Ab3LFRYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:24:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3LFRYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:24:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI on ARM64
Date: Fri, 6 Dec 2013 18:23:26 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linaro-kernel@lists.linaro.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        patches@linaro.org, Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <201312052304.22302.arnd@arndb.de> <52A1E794.1040008@linaro.org>
In-Reply-To: <52A1E794.1040008@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201312061823.26481.arnd@arndb.de>
X-Provags-ID: V02:K0:0JaQuxxThcoVxcFSJePauBilpu0nVSLU2XlPvNXjtRY
 vVH2WElzMo3de6VaLyeOLSuc1z5icOh4nYUzL6GhO4Df0tS/XO
 RJ0k9AT3s4fwxM48drLEuorHtBEsXiEexUEKUXA42k73DUP+VX
 ROQfcjCc//EbdS6MaZdRTVI4dEQJy6rOI951p1Jq7BB2whFuKa
 hfEhqTVV7jFpiLjqZBk8ZgeNCfKtj1EvZ6A/HAzDriRtMjt07K
 mE3MPA3+W2svCZnmgH3TsBlyUT+E3h/wEYV3zLTXy1NZJpIfa0
 nN/96mFt7vOwxgy7ij0r5d4xVHj+o2klJaveo+4Fdph+PPZsOo
 tpDGL6+R852htkGr6ogs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013, Tomasz Nowicki wrote:
> On 05.12.2013 23:04, Arnd Bergmann wrote:
> > On Wednesday 04 December 2013, Hanjun Guo wrote:
> >> On 2013年12月04日 00:41, Matthew Garrett wrote:
> >>> Given the number of #ifdefs you're adding, wouldn't it make more sense
> >>> to just add stub functions to include/linux/pci.h?
> >>
> >> Thanks for the suggestion :)
> >>
> >> I can add stub functions in include/linux/pci.h for raw_pci_read()/
> >> raw_pci_write(), then can remove #ifdefs for acpi_os_read/write_pci_configuration().
> >
> > Actually I wonder about the usefulness of this patch in either form: Since ACPI
> > on ARM64 is only for servers, I would very much expect them to always come with
> > PCI, either physical host bridges with attached devices, or logical PCI functions
> > used to describe the on-SoC I/O devices. Even in case of virtual machines, you'd
> > normally use PCI as the method to communicate data about the virtio channels.
> >
> > Can you name a realistic use-case where you'd want ACPI but not PCI?
> 
> Yes you can describe SoC I/O devices using logical PCI functions only if 
> they are on PCI, correct me if I am wrong. Also, devices can be placed 
> only on IOMEM (like for ARM SoC) and it is hard to predict which way 
> vendors chose. So way don't let it be configurable? ACPI spec says 
> nothing like PCI is needed for ACPI, AFAIK.

You are right that today's ARM SoCs basically never use PCI to describe
internal devices (IIRC VIA VT8500 is an exception, but their PCI was
just a software fabrication).

However, when we're talking about ACPI on ARM64, that is nothing like classic
ARM SoCs: As Jon Masters mentioned, this is about new server hardware following
a (still secret, but hopefully not much longer) hardware specification that is
explicitly designed to allow interoperability between vendors, so they
must have put some thought into how to make the hardware discoverable. It
seems that they are modeling things after how it's done on x86, and the
only sensible way to have discoverable hardware there is PCI. This is
also what all x86 SoCs do.

	Arnd
