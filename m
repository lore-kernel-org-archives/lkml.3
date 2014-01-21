Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaAUGfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 01:35:03 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44420 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaAUGez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 01:34:55 -0500
MIME-Version: 1.0
In-Reply-To: <1390273543-18032-1-git-send-email-zhuangzhi.li@intel.com>
References: <1390273543-18032-1-git-send-email-zhuangzhi.li@intel.com>
Date: Tue, 21 Jan 2014 12:04:54 +0530
Message-ID: <CAKohponL_R8M40BJa3X+++1yDtw5KRvk88w8kVfA+_D+poK08A@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Align all CPUs to the same frequency if using
 shared clock
From: Viresh Kumar <viresh.kumar@linaro.org>
To: lizhuangzhi <zhuangzhi.li@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2014 08:35, lizhuangzhi <zhuangzhi.li@intel.com> wrote:
> Some SMP systems want to make all the possible CPUs share the clock,
> if the CPUs init frequencies aren't the same, we need to align all the
> CPUs to the same frequency while CPUs registing to avoid mismatched
> CPU's P-states.
>
> Signed-off-by: lizhuangzhi <zhuangzhi.li@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 8d19f7c..d00abb5 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -991,6 +991,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>          * CPU because it is in the same boat. */
>         policy = cpufreq_cpu_get(cpu);
>         if (unlikely(policy)) {
> +               /* according present policy to align all the cpus frequencies */
> +               cpufreq_driver->target(policy, policy->cur, CPUFREQ_RELATION_H);

I don't really understand why is this required? CPUs sharing clocks means
that CPUs runs on the same clock line and so all of them must be running
on same frequency. So, why do we need to call this routine? policy->cur
must be the current freq here for CPU in question.

--
viresh
