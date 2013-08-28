Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3H1Q07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:26:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37155 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3H1Q05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:26:57 -0400
Message-ID: <521E24CE.9090407@codeaurora.org>
Date: Wed, 28 Aug 2013 09:26:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] cpufreq: Don't use smp_processor_id() in preemptible
 context
References: <1377629249-1177-1-git-send-email-sboyd@codeaurora.org> <1377640884-16827-1-git-send-email-sboyd@codeaurora.org> <CAKohpo=RLmXK+vX9b7yBOGiS=d0ZEt3RpJETNvBeSRhYfoYWuA@mail.gmail.com>
In-Reply-To: <CAKohpo=RLmXK+vX9b7yBOGiS=d0ZEt3RpJETNvBeSRhYfoYWuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/13 23:34, Viresh Kumar wrote:
> On 28 August 2013 03:31, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> index b9b20fd..523af48 100644
>> --- a/drivers/cpufreq/cpufreq_governor.c
>> +++ b/drivers/cpufreq/cpufreq_governor.c
>> @@ -137,7 +137,7 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>>                 return;
>>
>>         if (!all_cpus) {
>> -               __gov_queue_work(smp_processor_id(), dbs_data, delay);
>> +               __gov_queue_work(policy->cpu, dbs_data, delay);
> This is probably wrong.. We wanted to queue work on current cpu and
> not policy->cpu.. Can you use raw_smp_processor_id()?

Ah right, for the case where the policy covers more than one cpu.
raw_smp_processor_id() would work but it probably also needs a large
comment. I'll resend with that.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

