Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3IZFRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:17:52 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52606 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3IZFRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:17:50 -0400
MIME-Version: 1.0
In-Reply-To: <1379699036-7380-1-git-send-email-yinghai@kernel.org>
References: <1379699036-7380-1-git-send-email-yinghai@kernel.org>
Date: Wed, 25 Sep 2013 22:17:49 -0700
X-Google-Sender-Auth: _7hCgmdKx69EbzaSjQbnnL63ZQg
Message-ID: <CAE9FiQV+K9QSEiRMA8BtqC8k2OHm4aZWODNL+vgfFmpsuBfzQg@mail.gmail.com>
Subject: Re: [PATCH -v2] cpufreq: skip loading acpi_cpufreq after intel_pstate
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 10:43 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> If the hw support intel_pstate and acpi_cpufreq, intel_pstate will
> get loaded first.
>
> acpi_cpufreq_init will call acpi_cpufreq_early_init()
> and that will allocate perf data and init those perf data in ACPI core,
> (that will cover all cpus). But later it will free them as
> cpufreq_register_driver(acpi_cpufreq) will fail as init_pstate is
> already registered
>
> Use cpufreq_get_current_driver() to check if we can skip the
> acpi_cpufreq loading.
>
> -v2: update changelog and separate second part to another patch, according
>      to Viresh.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  drivers/cpufreq/acpi-cpufreq.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> Index: linux-2.6/drivers/cpufreq/acpi-cpufreq.c
> ===================================================================
> --- linux-2.6.orig/drivers/cpufreq/acpi-cpufreq.c
> +++ linux-2.6/drivers/cpufreq/acpi-cpufreq.c
> @@ -986,6 +986,10 @@ static int __init acpi_cpufreq_init(void
>  {
>         int ret;
>
> +       /* don't keep reloading if cpufreq_driver exists */
> +       if (cpufreq_get_current_driver())
> +               return 0;
> +
>         if (acpi_disabled)
>                 return 0;
>

Rafael,

can you put this one in acpi tree?

Thanks

Yinghai
