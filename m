Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3LJJqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:46:09 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:59150 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3LJJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:45:59 -0500
MIME-Version: 1.0
In-Reply-To: <201312080344.56317.arnd@arndb.de>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
	<201312052325.02603.arnd@arndb.de>
	<20131206135825.GG29268@sirena.org.uk>
	<201312080344.56317.arnd@arndb.de>
Date: Tue, 10 Dec 2013 10:45:58 +0100
Message-ID: <CACRpkdYN6X=Qd1Fyy9dyM7FStMaMMDAQCzQOxX4cwHM-J00kHA@mail.gmail.com>
Subject: Re: [RFC part1 PATCH 0/7] Make ACPI core running on ARM64
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Patch Tracking <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Hanjun Guo <hanjun.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Jon Masters <jonathan@jonmasters.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 8, 2013 at 3:44 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> I'd agree as soon as someone can convince me that we actually want ACPI
> support in the kernel for ARM64 servers. As far as I'm concerned it's quite
> possible that the people who have worked on this for the past couple of
> years behind closed doors know what they are doing and it will all be
> good, but it's also possible that it turns into a huge trainwreck once
> we see multiple implementations that have fundamentally incompatible
> requirements regarding what they want from ACPI and we end up not doing
> it at all.

Here is a piece I've noticed very clearly in the GPIO subsystem:

ACPI is persued for x86 servers, desktops by all vendors. For
embedded x86 it is persued by Intel *ONLY*. We still get several
embedded GPIO drivers for x86 that use ISA-style portmapped I/O
probing (!)

So, hehe, in init/Kconfig there is still the much-debated Kconfig
option "EMBEDDED"...

Should ACPI for ARM64 be depends on !EMBEDDED?

Yours,
Linus Walleij
