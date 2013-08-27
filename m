Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3H0OUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:20:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36473 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059Ab3H0OUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:20:05 -0400
Date: Tue, 27 Aug 2013 16:19:58 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC v1 0/5] ARM: Initial support for Marvell Armada 1500
Message-ID: <20130827161958.5e71890d@skate>
In-Reply-To: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Fri, 16 Aug 2013 21:41:33 +0200, Sebastian Hesselbarth wrote:
> This is a RFC adding initial support for the Marvell Armada 1500
> (88DE3100) found on various consumer devices (Chromecast, GoogleTV).
> 
> Actually, it is a two-fold RFC also raising discussions on mach-mvebu
> cleanup roadmap to allow other SoCs to hop into it. While mach-mvebu
> originally was created to add support for Armada 370/XP and merge
> existing Marvell Orion familiy into it, I am not so sure about
> Armada 1500 fits that well (the mbus has gone!).

After talking a bit with engineers within Marvell that work on this
SoC, I'm inclined to think that using mach-mvebu for this family of SoC
is not a good idea.

The reasons are:

 * This family of SoC is architecturally completely different from the
   family of Orion SoC: they use completely different hardware blocks
   (i.e none of the plat-orion stuff would apply, and none of the
   Orion device drivers would be useful), they don't use the MBus
   mechanism, etc. They are really a different family of SoC, almost as
   if they were coming from a different SoC company.

 * The SMP and power management code, as well as all the "glue"
   platform code that typically sits in mach-<foo> is going to be
   substantially, if not completely different from the one in
   mach-mvebu. I already believe doing all the "glue" platform code in
   mach-mvebu for all of Kirkwood, Dove, 370/XP, Orion5x and MV78xx0 is
   going to be a challenge, so I'd suggest to not add to this challenge
   a completely separate family of SOCs.

The codename used for those Armada 1500 SOCs is "Berlin", so a name
like mach-berlin, or mach-mvberlin (if we want to keep 'mv' to identify
the founder) seems like a good name.

Also, to help us understand the organization of the family of SOCs, I
asked a few informations to Marvell, and here is what I could collect:

"""
BGxname		CPU core	codename	L2 cache controller	internal name
BG2		PJ4B		Armada1500	Tauros3			MV88DE3100
BG2-CT		Cortex-A9	N/A		PL310			N/A
BG3		Cortex-A15	N/A		CA15 integrated		N/A
"""

As was told that the Armada X or MV88DEx names are not used during
development, and what Marvell is really using are the BGxx names.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
