Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab3BYMJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 07:09:51 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:57231 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3BYMJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 07:09:49 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1302251227140.3030@axis700.grange>
References: <Pine.LNX.4.64.1302251227140.3030@axis700.grange>
Date: Mon, 25 Feb 2013 17:39:47 +0530
X-Google-Sender-Auth: GHRQdL85Td4E5OolhGRa_CanJEg
Message-ID: <CAOh2x=n-G0BwhjH+VXgy=+nbsaH0+5FqWHhDoyU=xWp-EH9Zdg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: fix sign check of an unsigned variable in cpufreq-cpu0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mike Turquette <mturquette@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 5:02 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> A "< 0" test for an unsigned variable is meaningless, change the variable
> to signed.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> stable?
>
>  drivers/cpufreq/cpufreq-cpu0.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 52bf36d..e7bad3c 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -44,7 +44,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>  {
>         struct cpufreq_freqs freqs;
>         struct opp *opp;
> -       unsigned long freq_Hz, volt = 0, volt_old = 0, tol = 0;
> +       unsigned long volt = 0, volt_old = 0, tol = 0;
> +       long freq_Hz;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

The disease is spread across a bigger region though.

@Mike: clk_round_rate returns long and __clk_round_rate returns unsigned long
and clk_ops->round_rate returns long again.. Don't you see something
strange here?
