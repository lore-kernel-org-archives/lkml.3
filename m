Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3F1Dun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:50:43 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48544 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3F1Duk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:50:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130627164204.370dc4a6@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-6-git-send-email-l.majewski@samsung.com>
	<CAKohpo=EwapTp8epok30=_ZYLPeCR8_LhpBF5H724dE=+SwMLg@mail.gmail.com>
	<20130627125819.5c90da30@amdc308.digital.local>
	<CAKohpo=JKg17YWjTrOh25hHW=sXn8-TW=D8rhrovonwZBDarBg@mail.gmail.com>
	<20130627164204.370dc4a6@amdc308.digital.local>
Date: Fri, 28 Jun 2013 09:20:40 +0530
Message-ID: <CAKohpomrPP9Lzk+fMn+Ba+J+2N740LR5NurVMomx8zww3AWLww@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 June 2013 20:12, Lukasz Majewski <l.majewski@samsung.com> wrote:
> On Thu, 27 Jun 2013 16:46:44 +0530, Viresh Kumar wrote:
>> @Rafael: We need you to jump into this discussion now, I don't
>> have a good idea about what we should do :)
>>
>> On 27 June 2013 16:28, Lukasz Majewski <l.majewski@samsung.com> wrote:
>> > Do you have any idea of how to precisely set the load threshold?
>>
>> I thought we are talking about cpu being in idle state.
>
> If we _drop_ the idea with thermal subsystem to disable the boost,
> the logic as far as I've understood shall here be as follow:
>
> Only enable BOOST when one CPU load > THRESHOLD_MAX and other CPUs <
> THRESHOLD_MIN

Again, I thought that we are talking about cpus being completely idle.
i.e. in WFI (wait for interrupt) or deeper states.

> THRESHOLD_MIN & THRESHOLD_MAX are SoC specific.
>
> In my opinion the above constrain imposes policy to the cpufreq driver.

Hmm.

> So thermal or "other solution" [*] shall disable boost when overheated
> and enable it back when things cool down.

yeah..

> [*] @ Viresh & Rafael do you have any idea about the "other solution"
> here?

Not really sure :)

>> There might be platforms where overheating isn't a issue with boost,
>> if it is only enabled while only one cpu is in use.
>
> Could you elaborate more on this?

I meant platforms where chip doesn't heat up much when only one core
is in use and is using boost frequency. So, they may not require support
for thermal layer at all.. But I am not aware of what the ground reality is. If
such systems can be possible or not.

> This would prevent situation when somebody made a mistake and
> had enabled boost, but for some reason had forgotten to
> configure/enable thermal subsystem.
>
> Moreover Kconfig's CONFIG_CPUFREQ_BOOST flag would indicate that user
> enabled boost for some reason and he/she (presumably) knows what is
> doing.

Yeah.. And drivers like ACPI cpufreq and exynos can simply do a select
from their Kconfig entries so that user isn't required to select them.
