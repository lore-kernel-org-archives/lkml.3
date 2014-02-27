Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaB0FZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:25:21 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39419 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0FZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:25:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140226170847.GA18427@thin>
References: <1393432706-25708-1-git-send-email-rashika.kheria@gmail.com>
	<20140226164142.GA18079@thin>
	<CAMpEsFFjR2e_kDn9-QuKcS3RjsSmru9XGjXqXXdO7sYeWdh9dw@mail.gmail.com>
	<20140226170847.GA18427@thin>
Date: Thu, 27 Feb 2014 10:55:18 +0530
Message-ID: <CAKohpomqu22Pt5_wYV3u2uC36AgfmrkvxLtJCGakdodEQFE-jQ@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: cpufreq: Mark function as static in cpufreq.c
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: josh@joshtriplett.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rashika,

On 26 February 2014 22:08, Rashika Kheria <rashika.kheria@gmail.com> wrote:
> Mark function as static in cpufreq.c because it is not
> used outside this file.
>
> This eliminates the following warning in cpufreq.c:
> drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for 'show_boost' [-Wmissing-prototypes]

Can you please elaborate how this warning is related to
the non-static definition of this function?

> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
>  drivers/cpufreq/cpufreq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 08ca8c9..54fd670 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -352,7 +352,7 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
>  /*********************************************************************
>   *                          SYSFS INTERFACE                          *
>   *********************************************************************/
> -ssize_t show_boost(struct kobject *kobj,
> +static ssize_t show_boost(struct kobject *kobj,
>                                  struct attribute *attr, char *buf)
>  {
>         return sprintf(buf, "%d\n", cpufreq_driver->boost_enabled);
> --
> 1.7.9.5
>
