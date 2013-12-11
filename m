Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3LKDIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:08:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3LKDIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:08:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI on ARM64
Date: Wed, 11 Dec 2013 04:07:27 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Hanjun Guo <hanjun.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <201312102100.20570.arnd@arndb.de> <20131210202323.GJ11468@sirena.org.uk>
In-Reply-To: <20131210202323.GJ11468@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312110407.27848.arnd@arndb.de>
X-Provags-ID: V02:K0:4POhREwpkv66FP7gntIZqIJHx5D73VYhDN+lrJBB8hJ
 ojxQwjMfA6DnBrIC0yN7t3How5kqtdZCLyEsBP3ZvXaVn4py5L
 uyEapmdhJ23nzi2hOtKpkjLDhkARSDDe/yz0VFGEGA4fJ6M8yC
 Tekb321HeEdDmvuTtrRzxU526RQSzu27YoDXL1TzSCnPCYgzC/
 5JDKGSIvQFH6IrhnbYMaCcYXj1WWSY8Uaohml6eUw81/O16MEC
 i7ufxPaOjzq0cW21quoPpkhEFRSUOVAkmCn7SkiME4DSagnmt7
 agLxh+JNIYkRcg9Y/c0qosNL1uTmNLrESaoUkQftn30pOQbGCY
 nXU+ijw/1wyl5wplOkcY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 December 2013, Mark Brown wrote:
> On Tue, Dec 10, 2013 at 09:00:20PM +0100, Arnd Bergmann wrote:
> > On Tuesday 10 December 2013, Mark Brown wrote:
> 
> > > It's not just the SoC, it's also the rest of the board.  The patches the
> > > Intel guys are submitting at the minute are mainly for the off-SoC
> > > devices at least as far as I noticed.  This'll impact anyone who ends up
> > > using ACPI, we need to at least pay attention to what's going on there.
> 
> > Yes, but I'm not that worried about off-soc stuff, which tends to be
> > off the much simpler variety: a few MMIO or PIO registers, IRQs,
> > GPIOs or (with ACPI-5.0) devices on i2c and spi buses.
> 
> That's not my experience especially once you get into phone type
> hardware - there's not much complexity difference when gluing things
> into the system and the fact that it's connected by the board increases
> the amount of flexibility that has to be coped with.

Yes, that is probably right. The only argument that one can make about
the mobile phone case is that these devices are so complex that nobody
even bothers any more running upstream kernels on them on any CPU
architecture. If the kernel code is kept out of the mainline tree,
it doesn't matter to us what they use, and the developers don't gain
much by following any of the available firmware models either.

	Arnd
