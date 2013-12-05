Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3LEWF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:05:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60565 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3LEWFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:05:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI on ARM64
Date: Thu, 5 Dec 2013 23:04:22 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Hanjun Guo <hanjun.guo@linaro.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Mark Rutland <mark.rutland@arm.com>, linaro-kernel@lists.linaro.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>, patches@linaro.org,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jon Masters <jonathan@jonmasters.org>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <20131203164111.GA13447@srcf.ucam.org> <529F376F.8050005@linaro.org>
In-Reply-To: <529F376F.8050005@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201312052304.22302.arnd@arndb.de>
X-Provags-ID: V02:K0:lYFZCYQ4VYk2PrZfh+8mICnRDbEDbLMS23KKkWw5aPI
 tGoVvuD9DagYnRGJMNZ+9D7doVpbO7xdJAX6CgCxmYXrDaAdYx
 DC3EJu5bbbUIkCJzrxKW0vuR+QMblS1DHUibXXvVJOuteyVuh4
 2Hs55SquxFYck4tUZP3Iq3V4L+yMC3rjYCsC3I/XLu1tjOz88z
 x3B9ecv6SVRf3mMB0N9HzfiPYeFVZ1KqdLyiSAf5SP2KTyjfN1
 g2GROY2P/asHYLcvumGtu+6PQOX4S3YswoH9AU9ISxLOZd3Uq2
 9Qxoo5753Q/WzrCec0xe6xKlMCnsnkePP1sfqhcoSQWvkiAiLO
 B5BLdmRHEuIipXQoNlK8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 December 2013, Hanjun Guo wrote:
> On 2013年12月04日 00:41, Matthew Garrett wrote:
> > Given the number of #ifdefs you're adding, wouldn't it make more sense
> > to just add stub functions to include/linux/pci.h?
> 
> Thanks for the suggestion :)
> 
> I can add stub functions in include/linux/pci.h for raw_pci_read()/
> raw_pci_write(), then can remove #ifdefs for acpi_os_read/write_pci_configuration().

Actually I wonder about the usefulness of this patch in either form: Since ACPI
on ARM64 is only for servers, I would very much expect them to always come with
PCI, either physical host bridges with attached devices, or logical PCI functions
used to describe the on-SoC I/O devices. Even in case of virtual machines, you'd
normally use PCI as the method to communicate data about the virtio channels.

Can you name a realistic use-case where you'd want ACPI but not PCI?

	Arnd
