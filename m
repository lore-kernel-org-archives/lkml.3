Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3LJD3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:29:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63460 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3LJD3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:29:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI on ARM64
Date: Tue, 10 Dec 2013 04:28:52 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
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
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <201312091735.05014.arnd@arndb.de> <20131209170617.GC30717@srcf.ucam.org>
In-Reply-To: <20131209170617.GC30717@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312100428.52588.arnd@arndb.de>
X-Provags-ID: V02:K0:XUU7OL4mCKZcPX3lz8lK2KSupVUY0Jv2HqSVtaTabwF
 KPCYwLaBUWzpwgVnbkWMHeuea1oDSDnnnud8nSUPBIZDbHICk5
 pYJuZfTVXtHSgsKdb58tl8Wn/tmaWetZp0L5Id5SqeyBBJi3aS
 MX4mi37PjQFVTKmIRNRoaqKiIe2C6GM32dp63V+/JzmyUZojaT
 JatTROetLjdbEm7uN+fU4p51QTRutOvU54OG5GkCXzpZarH9TT
 3TlBIp8m2vIjUWN41gBMUro2K85i4JS9UQET6MJygVNV1P0rn/
 daZArd93sssJ/cFHZTgTHBv3druKdkigBWRpS1jp+dLw8W9gq1
 v/42MQD5edWlhUCLlzLw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013, Matthew Garrett wrote:
> 
> On Mon, Dec 09, 2013 at 05:35:04PM +0100, Arnd Bergmann wrote:
> 
> > Exactly. In particular we don't want people to get the wrong idea about
> > where we are heading, so making it possible to use this code on embedded
> > systems for me is a reason not to take the patch.
> 
> People are trying to deploy ACPI-based embedded x86, and most of the 
> ACPI/DT integration discussion seems to have been based on the idea that 
> this is a worthwhile thing to support. If we're not interested in doing 
> so then we should probably make that a whole kernel decision rather than 
> a per architecture one.

Well, except it's not an architecture independent decision. An embedded
x86 SoC will still be very much like a PC, just with a few things added
in and some other bits left out, and you can already describe it mostly
with plain ACPI-5.0. Also, there are only a couple of different non-PC style
devices that Intel is integrating into their SoCs, so we're talking
about a few dozen device drivers here.

The embedded ARM SoCs we have are very much unlike a PC in lots of ways
and there are orders of magnitude more SoCs and on-chip devices that
are potentially impacted by this, so it's definitely not the same thing.

ARM developers are still licking the wounds from a painful migration
from board files to DT, and we will probably spend at least one or
two more years tying up the loose ends from that before we can actually
call that done. We are not ready to go through the same process (or worse)
again any time soon just because x86 does it, and the only reason we're
talking about this for servers is the promise that this is contained to
server-class systems with hardware and firmware people that know what
they are doing and that can make this work as easy as x86 servers
without adding a whole lot of complexity into the kernel.

	Arnd
