Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3GZL03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:26:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50843 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab3GZL01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:26:27 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-ad-51f25ce25a2f
Date: Fri, 26 Jul 2013 13:26:17 +0200
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
        Kukjin Kim <kgene.kim@samsung.com>, durgadoss.r@intel.com
Subject: Re: [PATCH v6 6/8] cpufreq:exynos:Extend Exynos cpufreq driver to
 support boost framework
Message-id: <20130726132617.567f2cbf@amdc308.digital.local>
In-reply-to: <CAKohponC=S=3=mrTpWvPvejqSeqfndVOwb2GDkQ0jKxXXa0TOQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-7-git-send-email-l.majewski@samsung.com>
 <CAKohponC=S=3=mrTpWvPvejqSeqfndVOwb2GDkQ0jKxXXa0TOQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xgO6jmE+BBif2C1hsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRtcXnXHDaLz71HGC36F/YyWTx52MdmsfGr
	hwOvx+I9L5k87lzbw+axbtpbZo++LasYPR4tbmH0OH5jO5PH501yAexRXDYpqTmZZalF+nYJ
	XBkv39xiLvjOXdF+5iJTA+M6zi5GTg4JAROJi3N3MEPYYhIX7q1n62Lk4hASWMQosaf5DQuE
	084kcfFGKyNIFYuAqsTfdS/YQGw2AT2Jz3efMnUxcnCICGhJvLyZClLPLPCXWaLvUQMbSFxY
	IEXi7qp8kHJeAWuJq9e7wZZxCgRL3GiZzA4xv41JYv2uU+wgCX4BSYn2fz+gLrKTOPdpAztE
	s6DEj8n3WEBsZqBdm7c1sULY8hKb17xlnsAoOAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERxJz6R2MK5ssDjEKMDBqMTDq+D0MVCINbGsuDL3EKMEB7OSCO9170+B
	QrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhj7g6QOH5zO
	KWx5/egnUx/lDhGJKSmmKW81OXcdClx8wOWqfd1jnknH3mx6FqvG97A56mC0/rel1x0rkz84
	dZu/LHGYuuSZZaPsXJHFCyJPvTAwVkuzSygWSGlxa/PSe+x/dre12M43L9p26NlkzlRhzVVu
	uJtpznh6b9izJQqMfNNrVqgIGCqxFGckGmoxFxUnAgAFIRMYoAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 15:56:53 +0530 Viresh Kumar wrote,
> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> 
> > diff --git a/drivers/cpufreq/exynos-cpufreq.c
> > b/drivers/cpufreq/exynos-cpufreq.c index 9ae1871..175172d9 100644
> > --- a/drivers/cpufreq/exynos-cpufreq.c
> > +++ b/drivers/cpufreq/exynos-cpufreq.c
> > @@ -270,6 +270,9 @@ static int exynos_cpufreq_cpu_exit(struct
> > cpufreq_policy *policy)
> >
> >  static struct freq_attr *exynos_cpufreq_attr[] = {
> >         &cpufreq_freq_attr_scaling_available_freqs,
> > +#ifdef CONFIG_CPU_FREQ_BOOST_SW
  	    ^^^^^^^^^^^^^^^^^^^^^^^^^ [*]
> 
> Use ARM_EXYNOS_CPU_FREQ_BOOST_SW instead.

For the reasons explained at [PATCH v6 5/8] I would prefer to leave [*]
here.

> 
> > +       &cpufreq_freq_attr_scaling_boost_freqs,
> > +#endif
> >         NULL,
> >  };
> >
> > @@ -332,6 +335,9 @@ static int __init exynos_cpufreq_probe(struct
> > platform_device *pdev)
> >
> >         locking_frequency = exynos_getspeed(0);
> >
> > +#ifdef CONFIG_CPU_FREQ_BOOST_SW
> > +       exynos_driver.boost_supported = true;
> > +#endif
> 
> So, why here and not in the definition of exynos_driver?

Right. I will move this to struct cpufreq_driver exynos_driver.

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
