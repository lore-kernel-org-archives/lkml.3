Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaBLFBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:01:46 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:48844 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBLFBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:01:17 -0500
MIME-Version: 1.0
In-Reply-To: <1392135847-30791-9-git-send-email-joshc@codeaurora.org>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
	<1392135847-30791-9-git-send-email-joshc@codeaurora.org>
Date: Wed, 12 Feb 2014 10:31:17 +0530
Message-ID: <CAKohponRmoV=hLcMfhULDUkaOuChdnAVFt4BpgSaz=0Qxr=yJA@mail.gmail.com>
Subject: Re: [PATCH 8/8] cpufreq: ppc: make use of of_find_matching_node_and_match
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2014 21:54, Josh Cartwright <joshc@codeaurora.org> wrote:
> Instead of the of_find_matching_node()/of_match_node() pair, which requires two
> iterations through the match table, make use of of_find_matching_node_and_match(),
> which only iterates through the table once.
>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/cpufreq/ppc-corenet-cpufreq.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
> index 051000f..041ef3a 100644
> --- a/drivers/cpufreq/ppc-corenet-cpufreq.c
> +++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
> @@ -278,7 +278,7 @@ static int __init ppc_corenet_cpufreq_init(void)
>         const struct soc_data *data;
>         unsigned int cpu;
>
> -       np = of_find_matching_node(NULL, node_matches);
> +       np = of_find_matching_node_and_match(NULL, node_matches, &match);
>         if (!np)
>                 return -ENODEV;
>
> @@ -288,7 +288,6 @@ static int __init ppc_corenet_cpufreq_init(void)
>                 cpumask_copy(per_cpu(cpu_mask, cpu), cpu_core_mask(cpu));
>         }
>
> -       match = of_match_node(node_matches, np);
>         data = match->data;
>         if (data) {
>                 if (data->flag)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
