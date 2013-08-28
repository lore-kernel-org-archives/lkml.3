Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3H1Fhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:37:41 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:63799 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3H1Fhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:37:39 -0400
MIME-Version: 1.0
In-Reply-To: <1377629249-1177-1-git-send-email-sboyd@codeaurora.org>
References: <CAKohpoktPNtSMRn0dEVjcEW5_62E+_UEgySOBJ-hG+r=NU3V2w@mail.gmail.com>
	<1377629249-1177-1-git-send-email-sboyd@codeaurora.org>
Date: Wed, 28 Aug 2013 11:07:39 +0530
Message-ID: <CAKohpomMqTjLXaJ9RA8DEXk=8xzJ2g0zVBujat6ComLX4kMobg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix timer/workqueue corruption due to double queueing
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

On 28 August 2013 00:17, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Sure that works just as well. Here's a patch.
>
>  drivers/cpufreq/cpufreq_governor.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 7b839a8..b9b20fd 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -133,6 +133,9 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  {
>         int i;
>
> +       if (!policy->governor_enabled)
> +               return;
> +
>         if (!all_cpus) {
>                 __gov_queue_work(smp_processor_id(), dbs_data, delay);
>         } else {

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
