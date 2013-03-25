Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab3CYWgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:36:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933435Ab3CYWgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:36:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
Date: Mon, 25 Mar 2013 22:36:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com> <20130325172633.GP30923@n2100.arm.linux.org.uk> <5150C16A.3040208@gmail.com>
In-Reply-To: <5150C16A.3040208@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303252236.23270.arnd@arndb.de>
X-Provags-ID: V02:K0:kSco9x/x/mz2MiK5TsT5jRoAWXWrgNUiEfw4GKCOHVT
 Fst19shejWel4rMLujHvtxiawXh9SxsOQZ7Vr3t/P9uPDG5X9k
 gIs93c3FxX+z1gAanNWIokA5lZWiDpuoFsT0CV154PEhWpgXUZ
 50hi6LzBfjldE98WWlfgqVub34b3W53jEKcMX5BlNtpHNO1VAG
 mHXovKWhvxyHca7SPkUA6oldA+hYAlXBjgZF2CuS37ex7bUT8R
 KHIJQ5Yi3/bJZzhIa1SGKWThDwq4nJWgGmiWfriR4/AD8RDE5c
 TU70qRu4R9ROS4tcThcyr3fRlIcMSmcqRQdfW9h9TXtVRFtn4u
 Glhgi3yQ8I+GATipS5TQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Rob Herring wrote:
> I count integrator-cp, realview, versatile and non-DT VExpress that do
> this (not surprisingly) and 25 platforms or timer implementations plus
> arm64 that do sched_clock setup in time_init. What's broken by not
> moving these earlier?

timekeeping_init() will leave the persistent_clock_exist variable as "false",
which is read in rtc_suspend() and timekeeping_inject_sleeptime().

For all I can tell, you will get a little jitter every time you
do a suspend in that case. Or perhaps it means the system clock
will be forwarded by the amount of time spent in suspend twice
after wakeup, but I'm probably misreading the code for that case.

	Arnd
