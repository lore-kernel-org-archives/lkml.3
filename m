Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab3HGXOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:14:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59814 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933540Ab3HGXOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:14:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH] cpufreq: exynos5440: Fix to skip when new frequency same as current
Date: Thu, 08 Aug 2013 01:25:08 +0200
Message-ID: <2331427.ybQdfvflPh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpom0gPk9BXRP2eEuX_HBXDut=wynrZfvOH1tcEQY6CMLNQ@mail.gmail.com>
References: <1375874171-16951-1-git-send-email-amit.daniel@samsung.com> <52022FC2.2010109@arm.com> <CAKohpom0gPk9BXRP2eEuX_HBXDut=wynrZfvOH1tcEQY6CMLNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 07, 2013 05:03:59 PM Viresh Kumar wrote:
> On 7 August 2013 17:00, Sudeep KarkadaNagesha
> <Sudeep.KarkadaNagesha@arm.com> wrote:
> > Any particular reason we need this check in all drivers after your
> > commit: 5a1c0228 "cpufreq: Avoid calling cpufreq driver's target()
> > routine if target_freq == policy->cur"
> >
> > I think it can removed from all drivers, am I missing something ?
> 
> Yeah.. Just a bit though :)
> 
> So, cpufreq core checks this when we call target for any frequency.
> Now, cpufreq driver actually does a cpufreq_frequency_table_target()
> and so the frequency may vary than what is requested, in case
> requested frequency isn't picked from the table.
> 
> In such cases we check it again to be sure that we aren't at this
> frequency already..
> 
> Earlier I thought of calling cpufreq_frequency_table_target() in the
> core before calling target but dropped the idea as I wasn't sure of
> the side effects.
> 
> @Rafael: Do you see why we shouldn't/can't call
> cpufreq_frequency_table_target() from the core itself and so drivers
> never need to do it?

It looks like it would require us to redefine .target() to take next_state
instead of target_freq (at least in the acpi-cpufreq case), wouldn't it?

Rafael

