Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3H0Qvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:51:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37501 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753409Ab3H0Qvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:51:32 -0400
Date: Tue, 27 Aug 2013 18:51:29 +0200
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
Message-ID: <20130827185129.31bd0c9e@skate>
In-Reply-To: <521CD7B9.7060208@gmail.com>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130827161958.5e71890d@skate>
	<521CD7B9.7060208@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Tue, 27 Aug 2013 18:45:45 +0200, Sebastian Hesselbarth wrote:

> > After talking a bit with engineers within Marvell that work on this
> > SoC, I'm inclined to think that using mach-mvebu for this family of SoC
> > is not a good idea.
> 
> Thomas,
> 
> thanks for the info below. Reading a little bit through the GPL'ed
> source, I also quickly came to the same conclusion. It is more likely
> we can reuse some stuff from other SoCs than Orion or Armada 370/XP.

Yes, many of the IP blocks are for example DesignWare IPs, or ARM IPs
in the case of the Cortex-A based variants.

> > The codename used for those Armada 1500 SOCs is "Berlin", so a name
> > like mach-berlin, or mach-mvberlin (if we want to keep 'mv' to identify
> > the founder) seems like a good name.
> 
> I have already moved it under mach-mv88de3xxx as for now, all SoCs
> Marvell is providing as DE (Digital Entertainment) fit in that. I like
> mach-codename style more than plain numbers, maybe I rename the folder
> to mach-berlin before posting.

I also like mach-berlin a bit more than mach-mve88de3xxx, for a very
silly reason: when during a discussion you have to say mach-mv88de3xxx,
it's pretty annoying. We already have the horrible mach-mv78xx0, let's
not add more of this :)

> Speaking of "berlin", they found a 2WW bomb in my home town center today
> and are evacuating apartments. Mine too, so it looks like I'll have
> some time to prepare v2 tonight..

Doh!

> > Also, to help us understand the organization of the family of SOCs, I
> > asked a few informations to Marvell, and here is what I could collect:
> >
> > """
> > BGxname		CPU core	codename	L2 cache controller	internal name
> > BG2		PJ4B		Armada1500	Tauros3			MV88DE3100
> > BG2-CT		Cortex-A9	N/A		PL310			N/A
> > BG3		Cortex-A15	N/A		CA15 integrated		N/A
> > """
> >
> > As was told that the Armada X or MV88DEx names are not used during
> > development, and what Marvell is really using are the BGxx names.
> 
> Ok, I'll add that info to Marvell SoC documentation also.

That'd be nice indeed.

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
