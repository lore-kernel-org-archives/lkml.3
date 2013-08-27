Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3H0GbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:31:08 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43051 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3H0GbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:31:05 -0400
MIME-Version: 1.0
In-Reply-To: <1377557137-1157-1-git-send-email-sboyd@codeaurora.org>
References: <1377557137-1157-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 27 Aug 2013 12:01:03 +0530
Message-ID: <CAKohpoktPNtSMRn0dEVjcEW5_62E+_UEgySOBJ-hG+r=NU3V2w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix timer/workqueue corruption due to double queueing
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 August 2013 04:15, Stephen Boyd <sboyd@codeaurora.org> wrote:
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -133,7 +133,7 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  {
>         int i;
>
> -       if (!all_cpus) {
> +       if (!all_cpus || !policy->governor_enabled) {
>                 __gov_queue_work(smp_processor_id(), dbs_data, delay);
>         } else {
>                 for_each_cpu(i, policy->cpus)

Shouldn't we simply do this instead at the top of this function?

> +       if (!policy->governor_enabled)
> +              return;
