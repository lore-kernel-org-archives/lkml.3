Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3H1Gez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:34:55 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55227 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3H1Gey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <1377640884-16827-1-git-send-email-sboyd@codeaurora.org>
References: <1377629249-1177-1-git-send-email-sboyd@codeaurora.org>
	<1377640884-16827-1-git-send-email-sboyd@codeaurora.org>
Date: Wed, 28 Aug 2013 12:04:53 +0530
Message-ID: <CAKohpo=RLmXK+vX9b7yBOGiS=d0ZEt3RpJETNvBeSRhYfoYWuA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Don't use smp_processor_id() in preemptible context
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 August 2013 03:31, Stephen Boyd <sboyd@codeaurora.org> wrote:
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index b9b20fd..523af48 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -137,7 +137,7 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>                 return;
>
>         if (!all_cpus) {
> -               __gov_queue_work(smp_processor_id(), dbs_data, delay);
> +               __gov_queue_work(policy->cpu, dbs_data, delay);

This is probably wrong.. We wanted to queue work on current cpu and
not policy->cpu.. Can you use raw_smp_processor_id()?

>         } else {
>                 for_each_cpu(i, policy->cpus)
>                         __gov_queue_work(i, dbs_data, delay);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
