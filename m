Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3GZLVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:21:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43854 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab3GZLVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:21:30 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-d0-51f25bb82287
Date: Fri, 26 Jul 2013 13:21:20 +0200
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
Subject: Re: [PATCH v6 5/8] cpufreq:boost:Kconfig: Provide support for software
 managed BOOST
Message-id: <20130726132120.5b9cf32f@amdc308.digital.local>
In-reply-to: <CAKohpokL57mXSQooX=4LZKtjMxJoXAB4uuzj13fgr3Gs7Wcf0A@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-6-git-send-email-l.majewski@samsung.com>
 <CAKohpokL57mXSQooX=4LZKtjMxJoXAB4uuzj13fgr3Gs7Wcf0A@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xoO6O6E+BBt9W6VhsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRtcXnXHDaLz71HGC36F/YyWTx52MdmsfGr
	hwOvx+I9L5k87lzbw+axbtpbZo++LasYPR4tbmH0OH5jO5PH501yAexRXDYpqTmZZalF+nYJ
	XBl/ph5iKmiVqniyeBdLA+MrkS5GTg4JAROJTf9/M0HYYhIX7q1n62Lk4hASmM4osf7ZQ0YI
	p51J4vaDG+wgVSwCqhJn56wH62AT0JP4fPcpkM3BISKgJfHyZipIPbPAX2aJvkcNbCA1wgLx
	Eo1NB9hAangFrCXW7GMBCXMKBEucnD2dGWJ+G5PEnTdbwWbyC0hKtP/7wQxxkZ3EuU8bwPby
	CghK/Jh8D6yZGWjX5m1NrBC2vMTmNW+ZJzAKzkJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBEfSM+kdjKsaLA4xCnAwKvHwKjh9DBRiTSwrrsw9xCjBwawkwnvd+1Og
	EG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBsZtbkp+OpuK
	OlfIeao6CB7V8tL/+f/+aZneN+vfuEotFGt5sbV/+tfCHerbW5umPz8eU5mcMbvk8cnoefNf
	K9h8rb2rp/FtUtE2MdeHMwMqznjMXfT3QabFtVK2hVmxr74GNLm77egVDHl9UWHSw3dpz+0y
	bqfkB5sLabD19S/0PmEcu85HOU+JpTgj0VCLuag4EQClvq2OoAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 15:54:56 +0530 Viresh Kumar wrote,
> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > For safety reasons new flag - CONFIG_CPU_FREQ_BOOST_SW has been
> > added. Only after selecting "EXYNOS Frequency Overclocking -
> > Software" Kconfig
> 
> You shouldn't mention Exynos here and must do exynos stuff at the end
> in a separate patch. This one must be generic.

Please see below comments.

> 
> > option the software managed boost is enabled. It also selects
> > thermal subsystem to be compiled in. Thermal is necessary for
> > disabling boost and cooling down the device when overheating
> > detected.
> >
> > Boost _MUST_NOT_ work without thermal subsystem with properly
> > defined overheating temperatures.
> >
> > This option doesn't affect x86's ACPI hardware managed boost support
> > (i.e. Intel, AMD). In this situation boost management is embedded at
> > hardware.
> >
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> >
> > ---
> > Changes for v6:
> > - CPU_FREQ_BOOST_SW [1] is now defined as "invisible" bool option.
> > - Platform dependent ARM_EXYNOS_CPU_FREQ_BOOST_SW config option has
> > been added. It depends on ARM_EXYNOS_CPUFREQ options and selects
> >   EXYNOS_THERMAL with the main boost config [1].
> >
> > Changes for v5:
> > - New patch
> >
> >  drivers/cpufreq/Kconfig     |    3 +++
> >  drivers/cpufreq/Kconfig.arm |   16 ++++++++++++++++
> >  2 files changed, 19 insertions(+)
> >
> > diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> > index 534fcb8..3f058a3 100644
> > --- a/drivers/cpufreq/Kconfig
> > +++ b/drivers/cpufreq/Kconfig
> > @@ -23,6 +23,9 @@ config CPU_FREQ_TABLE
> >  config CPU_FREQ_GOV_COMMON
> >         bool
> >
> > +config CPU_FREQ_BOOST_SW
> > +       bool
> 
> Invisible is fine but this must be disabled by default and must
> depend on thermal, rather than moving dependency on platform's
> config.

The CPU_FREQ_BOOST_SW [1] is a generic flag (invisible).

I will add "default n" to it.
It shall be used at all BOOST dependent #ifdefs (generic + platform).



Also I've introduced the ARM_EXYNOS_CPU_FREQ_BOOST_SW [2] config
option. The CPU_FREQ_BOOST_SW option is selected from it.

Moreover the [2] depends on ARM_EXYNOS_CPUFREQ (which prevents from
accidental enable/disable). And it selects automatically the
EXYNOS_THERMAL, which is much better than depending only on THERMAL [3]
(the generic framework).

Depending only on [3], results at situation where SW BOOST can be
enabled at x86 or ARM target with only generic THERMAL support (which
doesn't protect from overheating).


So the proposed solution:
1. Defines global flag [1]
2. This flag is selected only when dependencies for more HW close flag
[2] are meet.
3. It is more natural to have Kconfig BOOST enable/disable checkbox at
platform cpufreq driver (with description closer to HW).
4. Other ARCHs can easily define similar to [2] flag and by it select
[1].

For me the approach proposed in this patch is more natural and provides
high protection level from accidental SW boost enable.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
