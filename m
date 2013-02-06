Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3BFCZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:25:51 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53441 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3BFCZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:25:49 -0500
MIME-Version: 1.0
In-Reply-To: <5111BCDA.1060507@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
	<1360088646-19104-3-git-send-email-dirk.brandewie@gmail.com>
	<CAOh2x=nYOf32jKqwwikgBS2oRHwmhZdVug=pLzQZWp-N2S9CGw@mail.gmail.com>
	<5111BCDA.1060507@gmail.com>
Date: Wed, 6 Feb 2013 07:55:48 +0530
X-Google-Sender-Auth: XZdEG3ndxH7oxo-WKWE-5dSj4hU
Message-ID: <CAOh2x=k8EwdrMzE2qQ+vat47WcmVHzJhZjntPnqNwMqAqibXVQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] cpufreq: Retrieve current frequency from scaling
 drivers with internal governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 7:45 AM, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> How about this?
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2817c3c..9c0eac4 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1182,7 +1182,12 @@ unsigned int cpufreq_quick_get(unsigned int cpu)
>
>         unsigned int ret_freq = 0;
>
>         if (policy) {
> -               ret_freq = policy->cur;
>
> +               if (cpufreq_driver && cpufreq_driver->setpolicy &&
> +                       cpufreq_driver->get) {
> +                       ret_freq = cpufreq_driver->get(cpu);
> +               } else {
> +                       ret_freq = policy->cur;
> +               }
>                 cpufreq_cpu_put(policy);

The problem is: You don't need to do get/put in your case at all.
