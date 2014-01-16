Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaAPJk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:40:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37871 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaAPJkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:40:18 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-59-52d7a8ff6c30
Date: Thu, 16 Jan 2014 10:40:08 +0100
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
        linux-samsung-soc@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH v12 0/7] cpufreq:boost: CPU Boost mode support
Message-id: <20140116104008.15b77a1f@amdc2363>
In-reply-to: <1389335623.2411.15.camel@rzhang1-mobl4>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1387549495-809-1-git-send-email-l.majewski@samsung.com>
 <20140107075824.59a1ed3c@amdc2363> <9268964.f27SUq68sj@vostro.rjw.lan>
 <1389335623.2411.15.camel@rzhang1-mobl4>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t9jAV2GldeDDFoPsVtsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWl3fNYbP43HuE0WLG+X1MFrcbV7BZnDl9idWif2Evk8WT
	h31sFhu/ejjweSze85LJ4861PWwe66a9ZfbYcrWdxaNvyypGj0eLWxg9jt/YzuTxeZNcAEcU
	l01Kak5mWWqRvl0CV8al7a9YCpqUK35MT29gXCDVxcjJISFgIrH47BVmCFtM4sK99WxdjFwc
	QgKLGCWutO+Acn4xSuyacBOsikVAVaLz2E5GEJtNQE/i892nTCC2iIC2xNyeU8wgDcwC3SwS
	xxpesYAkhAWcJCYvmAzWzAvU0H5gJ1icU8BUYtaVw6wQG74wSjTOmMgOkuAXkJRo//cD6iY7
	iXOfNrBDNAtK/Jh8D6yZWUBLYvO2JlYIW15i85q3zBMYBWchKZuFpGwWkrIFjMyrGEVTC5IL
	ipPSc430ihNzi0vz0vWS83M3MYIj7Jn0DsZVDRaHGAU4GJV4eHc8vBYkxJpYVlyZe4hRgoNZ
	SYTXe/n1ICHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2M
	Cl4XD//a6Wr/uvj1xJ3yVz6xSxRy64QVbqt4sITh5iWx0vlLv33Qbd9v/KPuRaP2xaN79ilw
	i7F4G57vNF/HtLCp63GZ8/1PsZLyDDPeuZ32rdhif1HQZfVNQ8Vtrrkmt3+Fi4k/8DFe98D2
	V+u/GY8q57mbn02Mb5I9u9YgoEb4GvPTdRPFlFiKMxINtZiLihMBQe6hIqwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> On Wed, 2014-01-08 at 01:35 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, January 07, 2014 07:58:24 AM Lukasz Majewski wrote:
> > > Hi Rafael,
> > 
> > Hi,
> > 
> > > > This patch series introduces support for CPU overclocking
> > > > technique called Boost.
> > > > 
> > > > It is a follow up of a LAB governor proposal. Boost is a LAB
> > > > component:
> > > > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> > > > 
> > > > Boost unifies hardware based solution (e.g. Intel Nehalem) with
> > > > software oriented one (like the one done at Exynos).
> > > > For this reason cpufreq/freq_table code has been reorganized to
> > > > include common code.
> > > > 
> > > > Important design decisions:
> > > > - Boost related code is compiled-in unconditionally to cpufreq
> > > > core and disabled by default. The cpufreq_driver is
> > > > responsibile for setting boost_supported flag and providing
> > > > set_boost callback(if HW support is needed). For software
> > > > managed boost, special Kconfig flag - CONFIG_CPU_FREQ_BOOST_SW
> > > > has been defined. It will be selected only when a target
> > > > platform has thermal framework properly configured.
> > > > 
> > > > - struct cpufreq_driver has been extended with boost related
> > > > fields: -- boost_supported - when driver supports boosting
> > > >         -- boost_enabled - boost state
> > > >         -- set_boost - callback to function, which is necessary
> > > > to enable/disable boost
> > > > 
> > > > - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost)
> > > > is visible _only_ when cpufreq driver supports Boost.
> > > > 
> > > > - No special spin_lock for Boost was created. The one from
> > > > cpufreq core was reused.
> > > > 
> > > > - The Boost code doesn't rely on any policy. When boost state is
> > > > changed, then the policy list is iterated and proper
> > > > adjustements are done.
> > > > 
> > > > - To improve safety level, the thermal framework is also
> > > > extended to disable software boosting, when thermal trip point
> > > > is reached. After cooling down the boost can be enabled again.
> > > > This emulates behaviour similar to HW managed boost (like x86)
> > > > 
> > > > Tested at HW:
> > > >        Exynos 4412 3.13-rc4 Linux
> > > >        Intel Core i7-3770 3.13-rc4 Linux
> > > > 
> > > > Above patches were posted on top of kernel_pm/bleeding-edge
> > > > (SHA1: bd0f3a5d9dce48a917ce1f1047534d79c725149)
> > > > 
> > > > Lukasz Majewski (7):
> > > >   cpufreq: Add boost frequency support in core
> > > >   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with
> > > > common boost solution
> > > >   cpufreq:boost:Kconfig: Provide support for software managed
> > > > BOOST cpufreq:exynos:Extend Exynos cpufreq driver to support
> > > > boost framework
> > > >   Documentation:cpufreq:boost: Update BOOST documentation
> > > >   cpufreq:exynos4x12: Change L0 driver data to
> > > > CPUFREQ_BOOST_FREQ thermal:exynos:boost: Automatic
> > > > enable/disable of BOOST feature (at Exynos4412)
> > > > 
> > > >  Documentation/cpu-freq/boost.txt          |   26 +++----
> > > >  drivers/cpufreq/Kconfig                   |    4 +
> > > >  drivers/cpufreq/Kconfig.arm               |   15 ++++
> > > >  drivers/cpufreq/acpi-cpufreq.c            |   86
> > > > +++++++-------------- drivers/cpufreq/cpufreq.c
> > > > | 118 ++++++++++++++++++++++++++++-
> > > > drivers/cpufreq/exynos-cpufreq.c          |    3 +
> > > > drivers/cpufreq/exynos4x12-cpufreq.c      |    2 +-
> > > > drivers/cpufreq/freq_table.c              |   56 ++++++++++++--
> > > > drivers/thermal/samsung/exynos_tmu_data.c |   12 +--
> > > > include/linux/cpufreq.h                   |   24 ++++++ 10 files
> > > > changed, 261 insertions(+), 85 deletions(-)
> > > > 
> > > 
> > > A gentle ping about BOOST patches.
> > > 
> > > Its been already acked by Viresh and Eduardo.
> > > 
> > > It applies on kernel_pm/bleeding_edge SHA1:
> > > 4836deb72c5e2a9af0cb2129c1149783a26d99ab
> > 
> > It looks like Rui is still looking into this.
> > 
> > Rui, are you fine with this series?
> > 
> Yes, I'm okay with the thermal related parts of this patch set.
> 

Rafael, gentle reminder about BOOST patches ... :-)

> thanks,
> rui
> > Rafael
> > 
> 
> 


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
