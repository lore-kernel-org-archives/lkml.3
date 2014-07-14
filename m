Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaGNGa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:30:28 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39499 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaGNGaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:30:15 -0400
MIME-Version: 1.0
In-Reply-To: <1405319337-11368-1-git-send-email-xerofoify@gmail.com>
References: <1405319337-11368-1-git-send-email-xerofoify@gmail.com>
Date: Mon, 14 Jul 2014 12:00:14 +0530
Message-ID: <CAKohpo=R4sjEGUFDt2yubfTQ+r1FO5RtFBYg8XROH-SYu90Zew@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix latency for cpufreq_info
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 July 2014 11:58, Nicholas Krause <xerofoify@gmail.com> wrote:
> This fixes the latency for the cpufreq policy to 1 million nanoseconds
> that calls the function pxa_cpu_init for the member of the structure
> called cpuinfo.transition_latency.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/cpufreq/pxa2xx-cpufreq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
> index e24269a..e08bb98 100644
> --- a/drivers/cpufreq/pxa2xx-cpufreq.c
> +++ b/drivers/cpufreq/pxa2xx-cpufreq.c
> @@ -372,7 +372,7 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
>         init_sdram_rows();
>
>         /* set default policy and cpuinfo */
> -       policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
> +       policy->cpuinfo.transition_latency = 1000000;
>
>         /* Generate pxa25x the run cpufreq_frequency_table struct */
>         for (i = 0; i < NUM_PXA25x_RUN_FREQS; i++) {

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
