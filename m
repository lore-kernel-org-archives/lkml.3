Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab3LPFmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:42:05 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44808 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3LPFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:42:03 -0500
Date: Sun, 15 Dec 2013 21:39:50 -0800
From: Olof Johansson <olof@lixom.net>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
Message-ID: <20131216053950.GA5822@quad.lixom.net>
References: <20131211235616.12661.19702.sendpatchset@w520>
 <20131211235626.12661.8865.sendpatchset@w520>
 <20131212010503.GI21531@quad.lixom.net>
 <CANqRtoTGuXnGT0LW+et0w6U6QOC8x8xx0OEEqxQH8X6EtWrEcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoTGuXnGT0LW+et0w6U6QOC8x8xx0OEEqxQH8X6EtWrEcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 07:12:58PM +0900, Magnus Damm wrote:
> Hi Olof,
> 
> On Thu, Dec 12, 2013 at 10:05 AM, Olof Johansson <olof@lixom.net> wrote:
> > Hi,
> >
> > A couple of small comments below.
> 
> Thanks for your feedback!
> 
> > On Thu, Dec 12, 2013 at 08:56:26AM +0900, Magnus Damm wrote:
> >> From: Magnus Damm <damm@opensource.se>
> >>
> >> Add Kconfig entries for CMT, MTU2, TMU and STI to
> >> drivers/clocksource/Kconfig. This will allow us to
> >> get rid of duplicated entires in architecture code
> >> such as arch/sh and arch/arm/mach-shmobile.
> >>
> >> Signed-off-by: Magnus Damm <damm@opensource.se>
> >> ---
> >>
> >>  drivers/clocksource/Kconfig |   44 +++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 44 insertions(+)
> >>
> >> --- 0001/drivers/clocksource/Kconfig
> >> +++ work/drivers/clocksource/Kconfig  2013-12-12 08:41:55.000000000 +0900
> >> @@ -134,3 +134,47 @@ config VF_PIT_TIMER
> >>       bool
> >>       help
> >>         Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> >> +
> >> +config SYS_SUPPORTS_CMT
> >> +        bool
> >> +
> >> +config SYS_SUPPORTS_TMU
> >> +        bool
> >> +
> >> +config SYS_SUPPORTS_MTU2
> >> +        bool
> >> +
> >> +config SYS_SUPPORTS_STI
> >> +        bool
> >
> > Maybe a prefix to avoid namespace collissions here?
> 
> Sure, that is fine with me. I based the ones above on already existing
> ones used by SH but I don't mind reworking those.
> 
> How about SYS_SUPPORTS_CLKSRC_xxx?

Oh, I was hoping for something shmobile-specific. Other platforms might have
some other clock source that they name STI or MTU, for example.

> >> +config SH_TIMER_CMT
> >> +     bool "Renesas CMT timer driver" if COMPILE_TEST
> >> +     default SYS_SUPPORTS_CMT
> >
> > It might be useful to have an explicit depends on ARCH_SH || ARCH_SHMOBILE
> > || COMPILE_TEST on these, just to make it easier for someone reading
> > the code later on.
> 
> I have any strong feelings one way or the other about that myself, but
> I got the impression that John Stultz preferred to not allow manual
> selection at all, and my compromise here is to allow it only when
> COMPILE_TEST is selected.
> 
> Would you be ok to keep it as-is for now? If needed then we can add an
> incremental patch later to enable more flexible selection.

Yeah, if there's no manual selection at all we might be fine.


-Olof
