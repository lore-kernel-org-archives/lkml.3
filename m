Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaIEO0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:26:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45091 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757094AbaIEO0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:26:09 -0400
Date: Fri, 5 Sep 2014 15:22:46 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Robert Richter <rric@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        Olof Johansson <olof@lixom.net>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Subject: Re: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium
 Thunder SoC Family
Message-ID: <20140905142245.GG20164@leverpostej>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
 <20140905110552.GH30401@n2100.arm.linux.org.uk>
 <20140905125147.GC20164@leverpostej>
 <7863371.EMkUuntQWU@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7863371.EMkUuntQWU@wuerfel>
Thread-Topic: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium
 Thunder SoC Family
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

[...]

> A common pattern these days is to do dependencies like
> 
> arch/*/Kconfig:
> 	config ARCH_FOO
> 	bool "Enable support for Foo platform"
> 	help
> 	  ...
> 
> 
> drivers/*/Kconfig
> 	config SUBSYS_FOO
> 	bool "SUBSYS driver for Foo"
> 	depends on ARCH_FOO || COMPILE_TEST
> 	depends on OF && REGULATOR && GENERIC_PHY # or whatever

Russell's comments w.r.t. Kconfig warnings when config names change
still holds regardless of select vs depends on.

> That way we can enable everything in the defconfig, but someone
> who likes to build a more specialized kernel can disable the
> other platforms and won't get the drivers that are specific to
> those.
> 
> I personally think this is a bit more verbose than what we need, but
> I don't strongly object doing it that way.

You'd still be able to do this without ARCH_FOO, though you would need
to know which drivers are necessary for a particular SoC. That seems to
be the way things are handled on x86; I don't recall having to select
support for specific machines there, just the individual drivers.

> The code size really should not matter much on ARM64 though: it's
> unlikely we will see a lot of systems with less than a few gigabytes
> of memory, and I expect that a generic kernel would be e.g. 6 MB
> instead of 4 MB for a platform specific kernel.

Agreed. If there kernel size begins looking unwieldy we either need to
be compiling more things as modules or a more drastic kernel weight loss
program.

Mark.
