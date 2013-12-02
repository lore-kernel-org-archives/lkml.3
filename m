Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3LBWUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:20:12 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55094 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752957Ab3LBWUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:20:08 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, ceh@ti.com
Subject: Re: [PATCH V4 1/2] cpufreq: Mark x86 drivers with CPUFREQ_SKIP_INITIAL_FREQ_CHECK flag
Date: Mon, 02 Dec 2013 23:33:04 +0100
Message-ID: <2171422.pY15ZQme4E@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <529CA5D5.9010008@gmail.com>
References: <0875dc1b263f39081232c560fc72c15cd42dfc6f.1385734305.git.viresh.kumar@linaro.org> <529CA5D5.9010008@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 02, 2013 07:23:01 AM Dirk Brandewie wrote:
> Sorry for late response to these threads.  Holiday weekend in the US.
> 
> On 11/29/2013 06:14 AM, Viresh Kumar wrote:
> > On some systems we can't really say what frequency we're running at the moment
> > and so for these we shouldn't check if we are running at a frequency present in
> > frequency table. For now mark all x86 drivers with this flag:
> > CPUFREQ_SKIP_INITIAL_FREQ_CHECK.
> >
> > This patch also defines this macro. It will be used in cpufreq.c in the next
> > patch.
> >
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> > V3->V4:
> > - Reversed the order of patches
> > - Moved definition of CPUFREQ_SKIP_INITIAL_FREQ_CHECK to patch 1/2 instead of
> >    2/2.
> >
> >   drivers/cpufreq/acpi-cpufreq.c       | 1 +
> >   drivers/cpufreq/cpufreq-nforce2.c    | 1 +
> >   drivers/cpufreq/e_powersaver.c       | 1 +
> >   drivers/cpufreq/elanfreq.c           | 1 +
> >   drivers/cpufreq/gx-suspmod.c         | 1 +
> >   drivers/cpufreq/ia64-acpi-cpufreq.c  | 1 +
> >   drivers/cpufreq/intel_pstate.c       | 2 +-
> 
> NAK for intel_pstate.  The code that will use this flag also uses has_target()
> which is false for intel_pstate.

Is your point that intel_pstate doesn't need to have this flag set?

> I think the logic for this patch is inverted. Why are we adding a flag to
> drivers where the bug cannot exist?

Well, enumerating goodness usually is a more sustainable strategy than
enumerationg badness, especially if the latter is more abundant. :-)

> I would be happier if the flag was
> CPUFREQ_NEED_INITIAL_FREQ_WORKAROUND to mark the platforms where the bug may 
> exist let those platforms cary the flag for the next 10+ years.
> 
> I still believe that this bug should be dealt with in platform specific code
> since this is working around a bootloader bug.  Are there platforms in the wild
> that even need this code or is this to support early platform bringup?

All it takes to introduce it is to use a buggy bootloader, so I guess
there's a number of potentially affected platforms out there.

This really isn't about which individual platforms have the problem, but about
which platforms have the property that the clock *can* be set to a wrong
frequency initially.  These are the ones we need to worry about regardless,
because we can't control boot loaders and duplicating the same code in
a number of drivers doesn't sound like a good approach.

So the only reasonable way forward I can see is to flag either the platforms
that we need to worry about, or the platforms that we don't need to worry
about and use that to decide whether or not to do the check.

Thanks,
Rafael

