Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298Ab3FSWRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:17:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43353 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935231Ab3FSWRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:17:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukasz Majewski <majess1982@gmail.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, l.majewski@majess.pl
Subject: Re: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
Date: Thu, 20 Jun 2013 00:26:42 +0200
Message-ID: <1875673.7IATFCnWBQ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130619225832.5ed70d4d@jawa>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <51C1F1E3.9010902@gmail.com> <20130619225832.5ed70d4d@jawa>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 10:58:32 PM Lukasz Majewski wrote:
> On Wed, 19 Jun 2013 11:01:07 -0700
> Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> 
> > On 06/19/2013 10:12 AM, Lukasz Majewski wrote:
> > > In the core governor code, per cpu load value is calculated. This
> > > patch uses it to mark processor as a "busy" one, when load value is
> > > higher than 90%.
> > >
> > > New cpufreq sysfs attribute is created (busy_cpus). It is read only
> > > and provides information about number of actually busy CPU.
> > >
> > 
> > What is the intended use of this interface?
> 
> The kernel API would be handy with boost managed by software (like it is
> done with exynos) and with LAB governor.
> 
> The intention is to have two save valves for boost:
> 
> 1. Enable SW controlled boost only when we have just one busy CPU.
> 
> 2. Use the Thermal subsystem to switch off SW managed boost when it
> detects that SoC is overheating.
> 
> The problem with 2 is that, the boost code is compiled in to the cpufreq
> core (no CONFIG_BOOST flag). Thereof we cannot guarantee, that thermal
> would be always enabled (the KConfig select option). 
> I think that thermal subsystem is a suitable place to disable SW boost
> at emergency. However in my opinion this is not enough and precaution
> defined at 1 is needed. 
> 
> I can remove exporting the "busy_cpu" sysfs attribute if you think, that
> it would confuse userspace. Its purpose is mainly informational.
> 
> > 
> > For drivers that have internal governors it will be misleading/wrong
> 
> Would you be so kind and give me an example of such an internal
> governor?
> 
> Maybe I've overlooked some important information/usecase.

Please look at intel_pstate.c.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
