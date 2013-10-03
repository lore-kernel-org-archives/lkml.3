Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab3JCFIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:08:41 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:38152 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3JCFIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <1380641424-5666-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1380641424-5666-1-git-send-email-mark.langsdorf@calxeda.com>
Date: Thu, 3 Oct 2013 10:38:37 +0530
X-Google-Sender-Auth: C31WCV_KOEHY8KWYrTSfXpq5GQM
Message-ID: <CAOh2x=mZ__gYkhi6o_goUkw+JB==VY2PSk-T_1G+6QBxDZGFFg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: highbank-cpufreq: Enable Midway/ECX-2000
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 9:00 PM, Mark Langsdorf
<mark.langsdorf@calxeda.com> wrote:
> Calxeda's new ECX-2000 part uses the same cpufreq interface as highbank,
> so add it to the driver's compatibility list.
>
> This is a minor change that can safely be applied to the 3.10 and 3.11
> stable trees.
>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> ---
>  drivers/cpufreq/highbank-cpufreq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> index 794123f..bf8902a 100644
> --- a/drivers/cpufreq/highbank-cpufreq.c
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -66,7 +66,8 @@ static int hb_cpufreq_driver_init(void)
>         struct device_node *np;
>         int ret;
>
> -       if (!of_machine_is_compatible("calxeda,highbank"))
> +       if ((!of_machine_is_compatible("calxeda,highbank")) &&
> +               (!of_machine_is_compatible("calxeda,ecx-2000")))
>                 return -ENODEV;
>
>         cpu_dev = get_cpu_device(0);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
