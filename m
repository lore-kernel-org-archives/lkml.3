Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbaDJDGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:06:51 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:25558 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934185AbaDJDGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:06:48 -0400
Message-ID: <53460AA9.7030801@huawei.com>
Date: Thu, 10 Apr 2014 11:06:17 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>
Subject: Re: [PATCH] cpufreq: highbank: fix ARM_HIGHBANK_CPUFREQ dependency
 warning
References: <1397010873-11020-1-git-send-email-wangkefeng.wang@huawei.com> <CAKohponpGAm4J2shQRV8doMZGT22eJ2MnU0+GzF-GkZirGPW5g@mail.gmail.com> <1453884.JQRzhD9Q31@vostro.rjw.lan>
In-Reply-To: <1453884.JQRzhD9Q31@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 04/10 10:18, Rafael J. Wysocki wrote:
> On Wednesday, April 09, 2014 09:58:26 AM Viresh Kumar wrote:
>> On 9 April 2014 08:04, Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>> When make ARCH=arm multi_v7_defconfig, we get the following warnings:
>>>
>>> warning: (ARM_HIGHBANK_CPUFREQ) selects GENERIC_CPUFREQ_CPU0 which has
>>> unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && HAVE_CLK
>>> && REGULATOR && OF && THERMAL && CPU_THERMAL)
>>>
>>> To fix this, make ARM_HIGHBANK_CPUFREQ depend on ARCH_HAS_CPUFREQ and
>>> REGULATOR instead of selecting them, PM_OPP will be selected by ARCH_HAS_CPUFREQ.
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> Well, it doesn't work as intended, I'm afraid:
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git bleeding-edge
> head:   588bc73d890c5dea35b7982a368c0e95089d5389
> commit: 51be80edc69390521622df71855d86da4e358488 [67/68] cpufreq: highbank: fix ARM_HIGHBANK_CPUFREQ dependency warning
> config: make ARCH=i386 allyesconfig
> 
> All warnings:
> 
> warning: (GENERIC_CPUFREQ_CPU0 && ARM_BIG_LITTLE_CPUFREQ && ARM_EXYNOS5440_CPUFREQ) selects PM_OPP which has unmet direct dependencies (ARCH_HAS_OPP)

I don't think this is my issue, without this patch，the warning is still there.

warning: (GENERIC_CPUFREQ_CPU0 && ARM_BIG_LITTLE_CPUFREQ && ARM_EXYNOS5440_CPUFREQ && ARM_HIGHBANK_CPUFREQ) selects PM_OPP which has unmet direct dependencies (ARCH_HAS_OPP)

this warning is caused by commit 109df086e(cpufreq: Select PM_OPP rather than depending on it),
so could you merge this patch? I will send a revert patch to solve this issue, what is your opinion?

Regards,
Kefeng

> 
>>> ---
>>>  drivers/cpufreq/Kconfig.arm | 6 +-----
>>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


