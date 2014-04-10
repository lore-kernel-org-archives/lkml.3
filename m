Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbaDJCC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 22:02:27 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57345 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933353AbaDJCCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 22:02:25 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        guohanjun@huawei.com
Subject: Re: [PATCH] cpufreq: highbank: fix ARM_HIGHBANK_CPUFREQ dependency warning
Date: Thu, 10 Apr 2014 04:18:26 +0200
Message-ID: <1453884.JQRzhD9Q31@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohponpGAm4J2shQRV8doMZGT22eJ2MnU0+GzF-GkZirGPW5g@mail.gmail.com>
References: <1397010873-11020-1-git-send-email-wangkefeng.wang@huawei.com> <CAKohponpGAm4J2shQRV8doMZGT22eJ2MnU0+GzF-GkZirGPW5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 09, 2014 09:58:26 AM Viresh Kumar wrote:
> On 9 April 2014 08:04, Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> > When make ARCH=arm multi_v7_defconfig, we get the following warnings:
> >
> > warning: (ARM_HIGHBANK_CPUFREQ) selects GENERIC_CPUFREQ_CPU0 which has
> > unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && HAVE_CLK
> > && REGULATOR && OF && THERMAL && CPU_THERMAL)
> >
> > To fix this, make ARM_HIGHBANK_CPUFREQ depend on ARCH_HAS_CPUFREQ and
> > REGULATOR instead of selecting them, PM_OPP will be selected by ARCH_HAS_CPUFREQ.
> >
> > Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Well, it doesn't work as intended, I'm afraid:

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git bleeding-edge
head:   588bc73d890c5dea35b7982a368c0e95089d5389
commit: 51be80edc69390521622df71855d86da4e358488 [67/68] cpufreq: highbank: fix ARM_HIGHBANK_CPUFREQ dependency warning
config: make ARCH=i386 allyesconfig

All warnings:

warning: (GENERIC_CPUFREQ_CPU0 && ARM_BIG_LITTLE_CPUFREQ && ARM_EXYNOS5440_CPUFREQ) selects PM_OPP which has unmet direct dependencies (ARCH_HAS_OPP)

> > ---
> >  drivers/cpufreq/Kconfig.arm | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
