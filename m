Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab3HSGuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:50:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28237 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3HSGur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:50:47 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-66-5211c045e5fc
Date: Mon, 19 Aug 2013 08:50:37 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: [PATCH v7 0/7] cpufreq:boost: CPU Boost mode support
Message-id: <20130819085037.11e95c06@amdc308.digital.local>
In-reply-to: <CAKohponN=JE4KiCL7pVXJvcf__qfC+Fb59ZjBAX5_WK49eCELw@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
 <CAKohponN=JE4KiCL7pVXJvcf__qfC+Fb59ZjBAX5_WK49eCELw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAV3XA4JBBnP3mllsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRtcXnXHDaLz71HGC1uN65gs+hf2Mtk8eRh
	H5vFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZdz6NoGt4JZMxa9VZQ2M+8W6GDk5JARMJBq+32eEsMUkLtxbz9bFyMUhJLCIUaLl
	RhsLhNPOJLHycDdQhoODRUBV4vVjM5AGNgE9ic93nzKBhEUEtCRe3kwFKWcW2Mkisez9LbCh
	wgKOEt339zOD2LwC1hLn5hxhArE5BYIl9nw9yQ4x/ySjxL+uu2wgCX4BSYn2fz+YIS6ykzj3
	aQM7RLOgxI/J91hAbGagZZu3NbFC2PISm9e8ZZ7AKDgLSdksJGWzkJQtYGRexSiaWpBcUJyU
	nmukV5yYW1yal66XnJ+7iREcUc+kdzCuarA4xCjAwajEw2vhJhgkxJpYVlyZe4hRgoNZSYSX
	RQ0oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgTFRO6im
	8lKB2Q5Hhlqzskd3/zzKMLvZON9qc+N/i/bdLpa3dJ6t2Mvf8XBD1l0OwUeLXmd0WjEzXbn9
	YVL6Lb3yWHb9gkMhV3sWJJ3mrve/MFd9T9WKqby8JtPUr+5e8e5zvrPhh2VVIWL+v2x2Nfod
	2bOMbc/GZKYJu849m77UIvbL2q+T9S4rsRRnJBpqMRcVJwIADpnWf6QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 12:08:26 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 13 August 2013 15:38, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> > This patch series introduces support for CPU overclocking technique
> > called Boost.
> >
> > It is a follow up of a LAB governor proposal. Boost is a LAB
> > component:
> > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> >
> > Boost unifies hardware based solution (e.g. Intel Nehalem) with
> > software oriented one (like the one done at Exynos).
> > For this reason cpufreq/freq_table code has been reorganized to
> > include common code.
> >
> > Important design decisions:
> > - Boost related code is compiled-in unconditionally to cpufreq core
> > and disabled by default. The cpufreq_driver is responsibile for
> > setting boost_supported flag and providing set_boost callback(if HW
> > support is needed). For software managed boost, special Kconfig
> > flag - CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be
> > selected only when a target platform has thermal framework properly
> > configured.
> >
> > - struct cpufreq_driver has been extended with boost related fields:
> >         -- boost_supported - when driver supports boosting
> >         -- boost_enabled - boost state
> >         -- set_boost - callback to function, which is necessary to
> >            enable/disable boost
> >
> > - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost) is
> > visible _only_ when cpufreq driver supports Boost.
> >
> > - No special spin_lock for Boost was created. The one from cpufreq
> > core was reused.
> >
> > - The Boost code doesn't rely on any policy. When boost state is
> > changed, then the policy list is iterated and proper adjustements
> > are done.
> >
> > - To improve safety level, the thermal framework is also extended
> > to disable software boosting, when thermal trip point is reached.
> > Then it starts monitoring target temperature to evaluate if boost
> > can be enabled again. This emulates behaviour similar to HW managed
> > boost (like x86)
> >
> > Tested at HW:
> >        Exynos 4412 3.11-rc4 Linux
> >        Intel Core i7-3770 3.11-rc4 Linux
> >
> > Above patches were posted on top of linux_pm/linux-next with
> > following patches applied:
> >
> > cpufreq: exynos5440: Fix to skip when new frequency same as current
> > cpufreq: fix EXYNOS drivers selection
> >
> > Lukasz Majewski (7):
> >   cpufreq: Add boost frequency support in core
> >   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with
> > common boost solution
> >   thermal:boost: Automatic enable/disable of BOOST feature
> >   cpufreq:boost:Kconfig: Provide support for software managed BOOST
> >   cpufreq:exynos:Extend Exynos cpufreq driver to support boost
> >     framework
> >   Documentation:cpufreq:boost: Update BOOST documentation
> >   cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
> 
> Hi Lukasz,
> 

Hi Viresh,

> I haven't found time yet to go through this series.. 

I've just started wondering if I had send those patches correctly :-).

> I want to do a
> deep/careful review this time as these are almost the final patches.

Ok.

> 
> Will try to get over them by the end of this week..

Ok, I understand.

> 
> --
> viresh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
