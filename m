Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab3BBCsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 21:48:50 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:49801 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab3BBCss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 21:48:48 -0500
MIME-Version: 1.0
In-Reply-To: <1359744545-18825-1-git-send-email-dirk.brandewie@gmail.com>
References: <359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
	<1359744545-18825-1-git-send-email-dirk.brandewie@gmail.com>
Date: Sat, 2 Feb 2013 08:18:47 +0530
X-Google-Sender-Auth: bq7nO-rcLA7v5U7tlLyzkTqhXzo
Message-ID: <CAOh2x=m2Q3dA0D6utMKa_KaHaiEBzy0-EQeHT+Ybobb9bupfxg@mail.gmail.com>
Subject: Re: [PATCH 1/6] cpufreq: Retrieve current frequency from scaling
 drivers with internal governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 12:19 AM,  <dirk.brandewie@gmail.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

> @@ -1219,6 +1219,9 @@ unsigned int cpufreq_quick_get(unsigned int cpu)
>         struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
>         unsigned int ret_freq = 0;
>
> +       if (cpufreq_driver && cpufreq_driver->setpolicy && cpufreq_driver->get)
> +               return cpufreq_driver->get(cpu);

You are required to do cpufreq_cpu_put() in this case too... Better do
cpufreq_cpu_get() after your check.

> +
>         if (policy) {
>                 ret_freq = policy->cur;
>                 cpufreq_cpu_put(policy);
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
