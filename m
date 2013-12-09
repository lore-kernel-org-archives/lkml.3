Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3LIRUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:20:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3LIRUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:20:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI on ARM64
Date: Mon, 9 Dec 2013 18:20:22 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
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
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <201312091735.05014.arnd@arndb.de> <20131209165548.GE19163@arm.com>
In-Reply-To: <20131209165548.GE19163@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312091820.23006.arnd@arndb.de>
X-Provags-ID: V02:K0:S9ablSPnD6OtDak+TcQFVEavlge1S22OBfXW8yvsAIL
 ChY5tVdEFZ3ZV4+c14EUZ5vkWmuHyLgABoZ9pBp8hAjLvfE0sE
 qL2MX5OhXYLkf0HsqPudxT7wDwI46+JXR1+wAYptGc67UhJrsv
 9LeEQjd+kY0pQQ9i/6akPEuLOvXXye7fMCiKop4f3eYr1nhuvT
 HsxgJp9r4UHRGvyCQm4QAsLEFZ3OQrFIBXrfQ6w2pt24BYMH4z
 06CvnUfgb7QvUcnYwNnqABNi5CgAzVqD7+uh/yS4e/FaiIryGk
 lJbEeeOWLJdBdNyLJm8Se8JXNkg/cSchzbRV47k/jVDiyrHdnQ
 Xgh5neBfjd0XzdCR9bM0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013, Catalin Marinas wrote:
> CONFIG_PCI does not exist on arm64 yet (we have some internal patches
> but may not be ready to be posted before the holidays; they try to share
> code with other archs, so more discussions before merging). We could add
> CONFIG_PCI and some dummy functions on arm64 for development (not to be
> upstreamed) or Hanjun could continue to use the current patch before we
> get PCI working. In the order of priorities, we'll have to merge PCI
> before ACPI anyway.

Well, lack of PCI support on ARM64 is a much better reason for accepting
the patch than potential use on non-server platforms of course.

What is the status of the PCI work though? I suspect it won't be all
that hard to add minimal PCI support for a simple mmconfig plus
fixed I/O space based host of the kind that qemu can easily provide.

The hard part that we want to share code with other architectures is
supporting pluggable host controllers, and I think we can defer that
a bit.

	Arnd
