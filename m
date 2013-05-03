Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab3ECMHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:07:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56420 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab3ECMHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:07:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH, RFC 02/22] cpufreq: ARM_DT_BL_CPUFREQ needs ARM_CPU_TOPOLOGY
Date: Fri, 03 May 2013 14:15:57 +0200
Message-ID: <5563691.6kxbXZTjH5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomBKuaxk+sSF63cu6JKut1uV7J7Sj2o85c3wQ=fodx+Ow@mail.gmail.com>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-3-git-send-email-arnd@arndb.de> <CAKohpomBKuaxk+sSF63cu6JKut1uV7J7Sj2o85c3wQ=fodx+Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 03, 2013 10:21:45 AM Viresh Kumar wrote:
> On 2 May 2013 20:46, Arnd Bergmann <arnd@arndb.de> wrote:
> > The big.LITTLE cpufreq driver uses the CPU topology API, which
> > needs to be reflected in Kconfig to prevent broken configurations.
> >
> > warning: (ARM_DT_BL_CPUFREQ) selects ARM_BIG_LITTLE_CPUFREQ which
> > has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && ARM && ARM_CPU_TOPOLOGY)
> >
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Cc: cpufreq@vger.kernel.org
> > Cc: linux-pm@vger.kernel.org
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/cpufreq/Kconfig.arm | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> > index f3af18b..3fd6bdf 100644
> > --- a/drivers/cpufreq/Kconfig.arm
> > +++ b/drivers/cpufreq/Kconfig.arm
> > @@ -10,6 +10,7 @@ config ARM_DT_BL_CPUFREQ
> >         tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
> >         select ARM_BIG_LITTLE_CPUFREQ
> >         depends on OF && HAVE_CLK
> > +       depends on ARM_CPU_TOPOLOGY
> >         help
> >           This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
> >           This gets frequency tables from DT.
> 
> This Kconfig thing has always been confusing to me. This is how the code looks
> currently.
> 
> config ARM_BIG_LITTLE_CPUFREQ
>         tristate
>         depends on ARM_CPU_TOPOLOGY
> 
> config ARM_DT_BL_CPUFREQ
>         tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
>         select ARM_BIG_LITTLE_CPUFREQ
>         depends on OF && HAVE_CLK
>         help
>           This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
>           This gets frequency tables from DT.
> 
> Because all ARM big LITTLE cpufreq stuff have dependency on
> ARM_CPU_TOPOLOGY, i have added dependency at a common place. So that
> we don't end up adding this in every glue layer driver. How should this be done?

First, there's no rule of thumb here as far as I can say.

In this particular case I think it is OK to make both ARM_DT_BL_CPUFREQ and
ARM_BIG_LITTLE_CPUFREQ depend on ARM_CPU_TOPOLOGY, because (in theory?) the
latter may be set without the former (unless you want to make ARM_DT_BL_CPUFREQ
depend on ARM_BIG_LITTLE_CPUFREQ, but then it may be kind of confusing to
users).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
