Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaHRHac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 03:30:32 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:55724 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaHRHaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 03:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <1408180966-15493-1-git-send-email-moon.linux@yahoo.com>
References: <1408180966-15493-1-git-send-email-moon.linux@yahoo.com>
Date: Mon, 18 Aug 2014 13:00:30 +0530
Message-ID: <CAKohpomeNmNA+7biiVqPWEx4UeiBj_GR2ccPVDpQADFzfs+XAw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq_opp: Fixed the order of argument for kcalloc.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Anand Moon <moon.linux@yahoo.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 August 2014 14:52, Anand Moon <moon.linux@yahoo.com> wrote:
> These changes fix the argument to the kcalloc
>         @n: number of elements.
>         @size: element size.
>         @flags: the type of memory to allocate (see kmalloc).
>
>         void *kcalloc(size_t n, size_t size, gfp_t flags)
>
> Signed-off-by: Anand Moon <moon.linux@yahoo.com>
> ---
>  drivers/cpufreq/cpufreq_opp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq_opp.c b/drivers/cpufreq/cpufreq_opp.c
> index f7a32d2..773bcde 100644
> --- a/drivers/cpufreq/cpufreq_opp.c
> +++ b/drivers/cpufreq/cpufreq_opp.c
> @@ -60,7 +60,7 @@ int dev_pm_opp_init_cpufreq_table(struct device *dev,
>                 goto out;
>         }
>
> -       freq_table = kcalloc(sizeof(*freq_table), (max_opps + 1), GFP_ATOMIC);
> +       freq_table = kcalloc((max_opps + 1), sizeof(*freq_table), GFP_ATOMIC);
>         if (!freq_table) {
>                 ret = -ENOMEM;
>                 goto out;

Fixes: 3c5445c cpufreq: OPP: Avoid sleeping while atomic

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
