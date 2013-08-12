Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3HLJwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 05:52:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60790 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3HLJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:52:34 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-bb-5208b060d414
Date: Mon, 12 Aug 2013 11:52:05 +0200
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
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: Re: [PATCH v6 6/8] cpufreq:exynos:Extend Exynos cpufreq driver to
 support boost framework
Message-id: <20130812115205.6fb12667@amdc308.digital.local>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jQd2EDRxBBte65C02zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aL3gVX2SzePOK2uLxrDpvF594jjBa3G1ewWfQv7GWyePKw
	j81i41cPBz6PxXteMnncubaHzWPdtLfMHn1bVjF6PFrcwuhx/MZ2Jo/Pm+QC2KO4bFJSczLL
	Uov07RK4Mlr3sBQ85q4481KwgXElZxcjJ4eEgIlE68kWVghbTOLCvfVsXYxcHEIC0xkl1u25
	wwrhtDNJ7FwyB6yKRUBVov/BPnYQm01AT+Lz3adMXYwcHCICWhIvb6aC1DMLrGCR2P9nMiNI
	XFggReLuqnyQcl4Ba4ndE4+DjeEUCJa40TKZHWJ+G5PE+l2nwGbyC0hKtP/7wQxxkZ3EuU8b
	2CGaBSV+TL7HAmIzA+3avK2JFcKWl9i85i3zBEbBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4Hh6Jr2DcVWDxSFGAQ5GJR5ejy/sQUKsiWXFlbmHGCU4mJVEeNXm
	cQQJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYOT1cP9R
	ppPSdO2+/YIattsGHxT8TJ6z1zsGP1fd5Cm8/EGV4YPpiqe3BdW1ybbfc2VneM8fV1K+4uHS
	/nWOix3+OPryeX0SqJtZIvHQfadik4+g0mXpnV56neZurdE3lgnf0OqNSri45YXVlc7ivge7
	48XnKvyc2rcy5bZJQKb1wVKHLZ+blViKMxINtZiLihMB0gcAMqMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 15:56:53 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
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
> 
> Use ARM_EXYNOS_CPU_FREQ_BOOST_SW instead.

Ok, the ARM_EXYNOS_CPU_FREQ_BOOST_SW looks more appropriate here.

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

Ok, I will move the above code to struct cpufreq_driver exynos_driver

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
