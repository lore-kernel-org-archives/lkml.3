Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaCJDxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 23:53:55 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51557 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaCJDxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 23:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <1394127279-29871-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394127279-29871-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Mon, 10 Mar 2014 11:53:53 +0800
Message-ID: <CAKohpo=E2PAD7XNm4y3tXv6-ArPCj+8RG-WsJLOfvJoZ7EkstQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Reformat printk() statement
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2014 01:34, Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> Reformat a printk statement to:
>  - use pr_warn
>  - bring the whole string into a single line in favor of being able to
>    grep for the message (ignoring the 80 char limit)
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  drivers/cpufreq/cpufreq.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index cb003a6b72c8..534c2df608ed 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1874,11 +1874,8 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>                 if (!gov)
>                         return -EINVAL;
>                 else {
> -                       printk(KERN_WARNING "%s governor failed, too long"
> -                              " transition latency of HW, fallback"
> -                              " to %s governor\n",
> -                              policy->governor->name,
> -                              gov->name);
> +                       pr_warn("%s governor failed, too long transition latency of HW, fallback to %s governor\n",
> +                                       policy->governor->name, gov->name);
>                         policy->governor = gov;
>                 }
>         }

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
