Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab3GPLuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:50:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23626 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3GPLud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:50:33 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-f3-51e533866fef
Date: Tue, 16 Jul 2013 13:50:22 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 6/7] cpufreq:boost:Kconfig: Enable software managed
 BOOST support at Kconfig
Message-id: <20130716135022.64a102f8@amdc308.digital.local>
In-reply-to: <CAKohpokR=jrcLQQ7VAD+vr7GWgSFBfuqbOhWHwA3FCgk__EJ3Q@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-7-git-send-email-l.majewski@samsung.com>
 <CAKohpokR=jrcLQQ7VAD+vr7GWgSFBfuqbOhWHwA3FCgk__EJ3Q@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xgG6b8dNAg2fd6hZ/3i5ntXja9IPd
	Yt5nWYs1+38yWXSefcJs0bvgKpvFm0fcFpd3zWGz+Nx7hNHiduMKNov+hb1MFk8e9rFZbPzq
	4cDrsXjPSyaPO9f2sHmsm/aW2aNvyypGj0eLWxg9jt/YzuTxeZNcAHsUl01Kak5mWWqRvl0C
	V8aVhvesBYfFKvovXGRrYGwQ7GLk5JAQMJH4ce0YO4QtJnHh3nq2LkYuDiGBRYwSnbfXs0M4
	7UwSc651sHYxcnCwCKhKdP+OBWlgE9CT+Hz3KRNIWERAS+LlzVSQcmaBj8wSdw/eZgGpERZI
	lfhw/RsriM0rYC2xa8JeNhCbUyBYYvOjd2A1QgItTBJrX9iC2PwCkhLt/34wQxxkJ3Hu0wZ2
	iF5BiR+T74HVMwPt2rytiRXClpfYvOYt8wRGwVlIymYhKZuFpGwBI/MqRtHUguSC4qT0XCO9
	4sTc4tK8dL3k/NxNjOA4eia9g3FVg8UhRgEORiUe3oOcTwKFWBPLiitzDzFKcDArifDe4n8a
	KMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoGxb8sO/Wbe
	Wv+yqbJrez5KtpctihINK21l6HZP3jTjuK73+oaIQ5EdK1+/WLpu3av+kzenXjowiaf+nKtz
	u+nze3WSD36s8O9pVUixn7KAeZ712X+Wlx3iq7YrTvsXcI/tw/cZLfe0zU9d0hYpE3tr8cXX
	4LdRy9F12nOi0rZmfX+QFdHyPbpbiaU4I9FQi7moOBEAdfP4VJ8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 15:28:40 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> 
> > +config CPU_FREQ_BOOST_SW
> > +       bool "CPU frequency overclocking (BOOST)"
> 
> Name it "CPU Frequency Overclocking - Software"

Thanks, I had a puzzle to came up with a good short name :-).

> 
> > +       depends on ARM_EXYNOS_CPUFREQ && EXYNOS_THERMAL && EXYNOS_THERMAL
 		       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [*]
> 
> Remote Exynos from here. If you want to enable it for your platform by
> default, then select it from EXYNOS.

The purpose of the condition [*] here is to prevent from enabling
boost when thermal for Exynos is not supported.

Only for properly configured Exynos (when thermal + cpufreq is set) the
option is possible to enable. And by default it is disabled.
This shall prevent from accidental boost usage. 
  

Please also note, that this switch only affects software based
boost. The HW boost (Intel ACPI) support doesn't depend on this Kconfig
setting. 

> 
> > +       default n
> > +       help
> > +        This driver supports software managed overclocking (BOOST).
> > +         It allows usage of special frequencies for a particular
> > processor
> > +         if thermal conditions are appropriate.
> > +
> > +        It reguires, for safe operation, thermal framework with
> > properly defined
> > +         trip points.
> > +
> > +        If in doubt, say N.
> > +
> >  config CPU_FREQ_STAT
> >         tristate "CPU frequency translation statistics"
> >         select CPU_FREQ_TABLE
> > diff --git a/drivers/cpufreq/exynos-cpufreq.c
> > b/drivers/cpufreq/exynos-cpufreq.c index 4f42fcc..7586b28 100644
> > --- a/drivers/cpufreq/exynos-cpufreq.c
> > +++ b/drivers/cpufreq/exynos-cpufreq.c
> > @@ -288,7 +288,9 @@ static struct cpufreq_driver exynos_driver = {
> >
> >  static int __init exynos_cpufreq_init(void)
> >  {
> > +#ifdef CONFIG_CPU_FREQ_BOOST_SW
> >         struct device_node *node = pdev->dev.of_node;
> > +#endif
> >         int ret = -EINVAL;
> >
> >         exynos_info = kzalloc(sizeof(struct exynos_dvfs_info),
> > GFP_KERNEL); @@ -319,9 +321,10 @@ static int __init
> > exynos_cpufreq_init(void) }
> >
> >         locking_frequency = exynos_getspeed(0);
> > +#ifdef CONFIG_CPU_FREQ_BOOST_SW
> >         if (of_property_read_bool(node, "boost_mode"))
> >                 exynos_driver.boost_supported = 1;
> > -
> > +#endif
> 
> Add a blank line here.

OK

> 
> >         register_pm_notifier(&exynos_cpufreq_nb);
> >
> >         if (cpufreq_register_driver(&exynos_driver)) {
> > --
> > 1.7.10.4
> >



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
