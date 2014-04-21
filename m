Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaDUFws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:52:48 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:36779 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaDUFwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:52:46 -0400
MIME-Version: 1.0
In-Reply-To: <1397728407-13909-2-git-send-email-geert+renesas@glider.be>
References: <1397728407-13909-1-git-send-email-geert+renesas@glider.be>
	<1397728407-13909-2-git-send-email-geert+renesas@glider.be>
Date: Mon, 21 Apr 2014 11:22:45 +0530
Message-ID: <CAKohpokx2uYH_xC0NZkuD06fQ3QiTLJKwW+YqKHcL-Zw+MGASw@mail.gmail.com>
Subject: Re: [PATCH 2/3] cpufreq: ppc: Fix integer overflow in expression
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 April 2014 15:23, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> On 32-bit, "12 * NSEC_PER_SEC" doesn't fit in "unsigned long"
> (NSEC_PER_SEC is a "long" constant), causing an integer overflow:
>
> drivers/cpufreq/ppc-corenet-cpufreq.c: In function 'corenet_cpufreq_cpu_init':
> drivers/cpufreq/ppc-corenet-cpufreq.c:211:9: warning: integer overflow in expression [-Woverflow]
>
> Force the intermediate to be 64-bit by adding an "ULL" suffix to the
> constant multiplier to fix this.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/cpufreq/ppc-corenet-cpufreq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
> index e78f9c806de4..53881d78a931 100644
> --- a/drivers/cpufreq/ppc-corenet-cpufreq.c
> +++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
> @@ -208,7 +208,7 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
>                 per_cpu(cpu_data, i) = data;
>
>         policy->cpuinfo.transition_latency =
> -                               (12 * NSEC_PER_SEC) / fsl_get_sys_freq();
> +                               (12ULL * NSEC_PER_SEC) / fsl_get_sys_freq();
>         of_node_put(np);
>
>         return 0;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
