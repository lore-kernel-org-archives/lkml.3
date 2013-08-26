Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3HZHGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:06:50 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:44700 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3HZHGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:06:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130826090255.01b1f299@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-2-git-send-email-l.majewski@samsung.com>
	<CAKohpo=m=smN-qk45dSdq8SOwAyqtE1xLV-Y85GaCbVhBDsmjQ@mail.gmail.com>
	<20130826090255.01b1f299@amdc308.digital.local>
Date: Mon, 26 Aug 2013 12:36:47 +0530
Message-ID: <CAKohpondC1BuODMauBsBKZtL=9sSDUSB6nXFKSoLWJG_xgO+iw@mail.gmail.com>
Subject: Re: [PATCH v7 1/7] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 August 2013 12:32, Lukasz Majewski <l.majewski@samsung.com> wrote:
> On Mon, 26 Aug 2013 10:58:53 +0530 Viresh Kumar viresh.kumar@linaro.org
> wrote,
>> Some minor nitpicking, nothing much :)
>
> Is there any chance to pull those corrected patches to v3.12?

Only Rafael can decide :)

> After your comments I think, that this code could be rewritten:
>
>
>         list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
>                 freq_table = cpufreq_frequency_get_table(policy->cpu);
>                 if (freq_table) {
>                         ret = cpufreq_frequency_table_cpuinfo(policy,
>                                                         freq_table);
>                         if (ret) {
>                                 pr_err("%s: Policy frequency update
>                                 failed\n")

Don't break strings into multiple lines even if they cross 80 columns..
And you missed __func__ :)

>                                 break;
>                         }
>
>                         policy->user_policy.max = policy->max;
>                         __cpufreq_governor(policy,CPUFREQ_GOV_LIMITS);
>                 }
>         }
>
>         return ret;
> }
