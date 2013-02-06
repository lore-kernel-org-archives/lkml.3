Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3BFBpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:45:55 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58415 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3BFBpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:45:49 -0500
MIME-Version: 1.0
In-Reply-To: <1360088646-19104-3-git-send-email-dirk.brandewie@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
	<1360088646-19104-3-git-send-email-dirk.brandewie@gmail.com>
Date: Wed, 6 Feb 2013 07:15:47 +0530
X-Google-Sender-Auth: 7OPcGYJRI_H23FasJwMYVZW-2FI
Message-ID: <CAOh2x=nYOf32jKqwwikgBS2oRHwmhZdVug=pLzQZWp-N2S9CGw@mail.gmail.com>
Subject: Re: [PATCH 2/7] cpufreq: Retrieve current frequency from scaling
 drivers with internal governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 11:54 PM,  <dirk.brandewie@gmail.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2817c3c..96bc302 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1181,6 +1181,13 @@ unsigned int cpufreq_quick_get(unsigned int cpu)
>         struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
>         unsigned int ret_freq = 0;
>
> +       if (cpufreq_driver && cpufreq_driver->setpolicy &&
> +               cpufreq_driver->get) {
> +               ret_freq = cpufreq_driver->get(cpu);
> +               cpufreq_cpu_put(policy);
> +               return ret_freq;
> +       }
> +

This was my comment on the last version:

"You are required to do cpufreq_cpu_put() in this case too... Better do
cpufreq_cpu_get() after your check."

It still applies.
