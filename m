Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484Ab3LISCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:02:19 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30853 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761277Ab3LISCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:02:15 -0500
Date: Mon, 9 Dec 2013 18:01:55 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
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
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core
 running without PCI on ARM64
Message-ID: <20131209180155.GG19163@arm.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <201312091735.05014.arnd@arndb.de>
 <20131209165548.GE19163@arm.com>
 <201312091820.23006.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312091820.23006.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:20:22PM +0000, Arnd Bergmann wrote:
> On Monday 09 December 2013, Catalin Marinas wrote:
> > CONFIG_PCI does not exist on arm64 yet (we have some internal patches
> > but may not be ready to be posted before the holidays; they try to share
> > code with other archs, so more discussions before merging). We could add
> > CONFIG_PCI and some dummy functions on arm64 for development (not to be
> > upstreamed) or Hanjun could continue to use the current patch before we
> > get PCI working. In the order of priorities, we'll have to merge PCI
> > before ACPI anyway.
> 
> Well, lack of PCI support on ARM64 is a much better reason for accepting
> the patch than potential use on non-server platforms of course.

As I said above about priorities, we are not in a hurry to merge ACPI
for arm64 before PCI is supported.

> What is the status of the PCI work though? I suspect it won't be all
> that hard to add minimal PCI support for a simple mmconfig plus
> fixed I/O space based host of the kind that qemu can easily provide.

Liviu (ARM engineer) has been working on generalising the microblaze
code (which is very similar to powerpc) and enable it on arm64. The
patches will be posted soon (though may slip into the new year) but
there will be many discussions on how to do this best, so I don't expect
a quick merge.

In parallel, Will is looking at getting PCI to work with kvmtool and
that's something we could merge sooner (but again, in the new year).

> The hard part that we want to share code with other architectures is
> supporting pluggable host controllers, and I think we can defer that
> a bit.

Indeed, this would take time.

-- 
Catalin
