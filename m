Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3FDFTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:19:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59781 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3FDFTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <51ACF2F1.1050600@semaphore.gr>
References: <51ACF2F1.1050600@semaphore.gr>
Date: Tue, 4 Jun 2013 10:49:06 +0530
Message-ID: <CAKohpomTRdHdKN3QUf0ba+gFXrEr=PbD4cJc8NSyNPmxfnUsMQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] cpufreq: Remove unused function __cpufreq_driver_getavg
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2013 01:18, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Calculation of frequency target in ondemand governor changed and it is

s/frequency target/target frequency

> independent from measured average frequency.
>
> Remove unused__cpufreq_driver_getavg function and getavg member from
> cpufreq_driver struct. Also, remove the callback getavg in
> acpi_cpufreq_driver.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/Makefile       |  2 +-
>  drivers/cpufreq/acpi-cpufreq.c |  5 -----
>  drivers/cpufreq/cpufreq.c      | 12 ------------
>  include/linux/cpufreq.h        |  6 ------
>  4 files changed, 1 insertion(+), 24 deletions(-)
>
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index 6ad0b91..aebd4ef 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -23,7 +23,7 @@ obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)    += cpufreq-cpu0.o
>  # powernow-k8 can load then. ACPI is preferred to all other hardware-specific drivers.
>  # speedstep-* is preferred over p4-clockmod.
>
> -obj-$(CONFIG_X86_ACPI_CPUFREQ)         += acpi-cpufreq.o mperf.o

Should this be done in 3/3 ?
