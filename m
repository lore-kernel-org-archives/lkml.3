Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3A1EhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:37:16 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:35337 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3A1EhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:37:11 -0500
MIME-Version: 1.0
In-Reply-To: <1358677470-17394-5-git-send-email-bp@alien8.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
	<1358677470-17394-5-git-send-email-bp@alien8.de>
Date: Mon, 28 Jan 2013 10:07:10 +0530
X-Google-Sender-Auth: yJYuWunrWWZ1_uSXByn8ibX6EUI
Message-ID: <CAOh2x==qf057z2vmADd6+thaXXVxEh1GZO-sKHRDyosqTfMdng@mail.gmail.com>
Subject: Re: [PATCH 4/6] cpufreq: Add a get_current_driver helper
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?ISO-8859-1?Q?Andr=E9_Przywara?= <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 3:54 PM, Borislav Petkov <bp@alien8.de> wrote:
> From: Borislav Petkov <bp@suse.de>
>
> Add a helper function to return cpufreq_driver->name.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/cpufreq/cpufreq.c | 14 ++++++++++++++
>  include/linux/cpufreq.h   |  1 +
>  2 files changed, 15 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 1f93dbd72355..6ed3c1377caf 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1386,6 +1386,20 @@ static struct syscore_ops cpufreq_syscore_ops = {
>         .resume         = cpufreq_bp_resume,
>  };
>
> +/**
> + *     cpufreq_get_current_driver - return current driver's name
> + *
> + *     Return the name string of the currently loaded cpufreq driver
> + *     or NULL, if none.
> + */
> +const char *cpufreq_get_current_driver(void)
> +{
> +       if (cpufreq_driver)
> +               return cpufreq_driver->name;
> +
> +       return NULL;
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_get_current_driver);
>
>  /*********************************************************************
>   *                     NOTIFIER LISTS INTERFACE                      *
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index a55b88eaf96a..a018da2d2a7c 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -407,4 +407,5 @@ void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
>                                       unsigned int cpu);
>
>  void cpufreq_frequency_table_put_attr(unsigned int cpu);
> +extern const char *cpufreq_get_current_driver(void);

Two minor things here:
- You placed the routine at bad place. This place is meant for
freq_table helpers.
- And you really don't need extern for function prototypes.

And after fixing these, feel free to add

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
