Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaAPP4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:56:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21935 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaAPP4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:56:16 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-be-52d8011f52a0
Date: Thu, 16 Jan 2014 16:56:02 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v12 0/7] cpufreq:boost: CPU Boost mode support
Message-id: <20140116165602.5d991e74@amdc2363>
In-reply-to: <63197714.M09EiGrl9g@vostro.rjw.lan>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1389335623.2411.15.camel@rzhang1-mobl4> <20140116104008.15b77a1f@amdc2363>
 <63197714.M09EiGrl9g@vostro.rjw.lan>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+xgK48440gg3+buCw2zljPavG06Qe7
	Rd/PK8wWa/b/ZLLoPPuE2eLNI26Ly7vmsFl87j3CaDHj/D4mi9uNK9gszpy+xGrx5GEfm8XG
	rx4OvB6L97xk8rhzbQ+bx7ppb5k9tlxtZ/Ho27KK0eP4je1MHp83yQWwR3HZpKTmZJalFunb
	JXBl3Pn0lrmgRaPi6YQLbA2Ms2W7GDk5JARMJC7ueMgIYYtJXLi3nq2LkYtDSGARo8TKk10s
	EM4vRonps28xdzFycLAIqEqsmC4M0sAmoCfx+e5TJhBbREBbYm7PKWaQemaBf8wS+3/9YQFJ
	CAs4SUxeMJkZxOYFapg04Rg7iM0pYCix4P5tRogFuxglfq49CpbgF5CUaP/3gxniJDuJc582
	sEM0C0r8mHwPbCizgJbE5m1NrBC2vMTmNW+ZJzAKzkJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525iBEfTM6kdjCsbLA4xCnAwKvHw7nh4LUiINbGsuDL3EKMEB7OSCK/E
	z+tBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhjFenZe
	jSveKb5xzY069wWqHXUT9wVpZD33Tsl/mHZzjYPI3WU3feQfL2/esUvlh9xEJr0wsdLe2dZX
	YjTVFkzxvObbINlgtJjx8ed09dLsM5P2Pf0Ts0HrLEPeBYsXjyfycOj8bu3LmjWRqVR7BvuX
	16d+LVt/cO/n19a+0w327dOZwR54qcdDiaU4I9FQi7moOBEAX2fD+aICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> On Thursday, January 16, 2014 10:40:08 AM Lukasz Majewski wrote:
> > Hi Rafael,
> > 
> > > On Wed, 2014-01-08 at 01:35 +0100, Rafael J. Wysocki wrote:
> > > > On Tuesday, January 07, 2014 07:58:24 AM Lukasz Majewski wrote:
> > > > > Hi Rafael,
> > > > 
> > > > Hi,
> > > > 
> > > > > > This patch series introduces support for CPU overclocking
> > > > > > technique called Boost.
> > > > > > 
> > > > > > It is a follow up of a LAB governor proposal. Boost is a LAB
> > > > > > component:
> > > > > > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> > > > > > 
> > > > > > Boost unifies hardware based solution (e.g. Intel Nehalem)
> > > > > > with software oriented one (like the one done at Exynos).
> > > > > > For this reason cpufreq/freq_table code has been
> > > > > > reorganized to include common code.
> > > > > > 
> > > > > > Important design decisions:
> > > > > > - Boost related code is compiled-in unconditionally to
> > > > > > cpufreq core and disabled by default. The cpufreq_driver is
> > > > > > responsibile for setting boost_supported flag and providing
> > > > > > set_boost callback(if HW support is needed). For software
> > > > > > managed boost, special Kconfig flag -
> > > > > > CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be
> > > > > > selected only when a target platform has thermal framework
> > > > > > properly configured.
> > > > > > 
> > > > > > - struct cpufreq_driver has been extended with boost related
> > > > > > fields: -- boost_supported - when driver supports boosting
> > > > > >         -- boost_enabled - boost state
> > > > > >         -- set_boost - callback to function, which is
> > > > > > necessary to enable/disable boost
> > > > > > 
> > > > > > - Boost sysfs attribute
> > > > > > (/sys/devices/system/cpu/cpufreq/boost) is visible _only_
> > > > > > when cpufreq driver supports Boost.
> > > > > > 
> > > > > > - No special spin_lock for Boost was created. The one from
> > > > > > cpufreq core was reused.
> > > > > > 
> > > > > > - The Boost code doesn't rely on any policy. When boost
> > > > > > state is changed, then the policy list is iterated and
> > > > > > proper adjustements are done.
> > > > > > 
> > > > > > - To improve safety level, the thermal framework is also
> > > > > > extended to disable software boosting, when thermal trip
> > > > > > point is reached. After cooling down the boost can be
> > > > > > enabled again. This emulates behaviour similar to HW
> > > > > > managed boost (like x86)
> > > > > > 
> > > > > > Tested at HW:
> > > > > >        Exynos 4412 3.13-rc4 Linux
> > > > > >        Intel Core i7-3770 3.13-rc4 Linux
> > > > > > 
> > > > > > Above patches were posted on top of kernel_pm/bleeding-edge
> > > > > > (SHA1: bd0f3a5d9dce48a917ce1f1047534d79c725149)
> > > > > > 
> > > > > > Lukasz Majewski (7):
> > > > > >   cpufreq: Add boost frequency support in core
> > > > > >   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work
> > > > > > with common boost solution
> > > > > >   cpufreq:boost:Kconfig: Provide support for software
> > > > > > managed BOOST cpufreq:exynos:Extend Exynos cpufreq driver
> > > > > > to support boost framework
> > > > > >   Documentation:cpufreq:boost: Update BOOST documentation
> > > > > >   cpufreq:exynos4x12: Change L0 driver data to
> > > > > > CPUFREQ_BOOST_FREQ thermal:exynos:boost: Automatic
> > > > > > enable/disable of BOOST feature (at Exynos4412)
> > > > > > 
> > > > > >  Documentation/cpu-freq/boost.txt          |   26 +++----
> > > > > >  drivers/cpufreq/Kconfig                   |    4 +
> > > > > >  drivers/cpufreq/Kconfig.arm               |   15 ++++
> > > > > >  drivers/cpufreq/acpi-cpufreq.c            |   86
> > > > > > +++++++-------------- drivers/cpufreq/cpufreq.c
> > > > > > | 118 ++++++++++++++++++++++++++++-
> > > > > > drivers/cpufreq/exynos-cpufreq.c          |    3 +
> > > > > > drivers/cpufreq/exynos4x12-cpufreq.c      |    2 +-
> > > > > > drivers/cpufreq/freq_table.c              |   56
> > > > > > ++++++++++++-- drivers/thermal/samsung/exynos_tmu_data.c
> > > > > > |   12 +-- include/linux/cpufreq.h                   |   24
> > > > > > ++++++ 10 files changed, 261 insertions(+), 85 deletions(-)
> > > > > > 
> > > > > 
> > > > > A gentle ping about BOOST patches.
> > > > > 
> > > > > Its been already acked by Viresh and Eduardo.
> > > > > 
> > > > > It applies on kernel_pm/bleeding_edge SHA1:
> > > > > 4836deb72c5e2a9af0cb2129c1149783a26d99ab
> > > > 
> > > > It looks like Rui is still looking into this.
> > > > 
> > > > Rui, are you fine with this series?
> > > > 
> > > Yes, I'm okay with the thermal related parts of this patch set.
> > > 
> > 
> > Rafael, gentle reminder about BOOST patches ... :-)
> 
> I'm about to take them for 3.14.
> 

Thanks :-)

> Thanks!
> 
> [PS: Please don't use the rjw@sisk.pl address, that domain is gone.]
> 

Ok, I will not use it.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
