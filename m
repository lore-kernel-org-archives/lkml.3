Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3JLN0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 09:26:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50968 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab3JLN0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 09:26:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: acpi: Add comment under ACPI_ADR_SPACE_SYSTEM_IO case
Date: Sat, 12 Oct 2013 15:38:15 +0200
Message-ID: <1922770.iubCDBg3Zg@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <6334c0aed4840857944d1b267871ada4d7014d57.1381541632.git.viresh.kumar@linaro.org>
References: <6334c0aed4840857944d1b267871ada4d7014d57.1381541632.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 12, 2013 07:06:03 AM Viresh Kumar wrote:
> policy->cur is now set by cpufreq core when cpufreq_driver->get() is defined and
> so drivers aren't required to set it. When space_id is ACPI_ADR_SPACE_SYSTEM_IO
> for acpi cpufreq driver it doesn't set ->get to a valid function pointer and so
> policy->cur is required to be set by driver.
> 
> This is already followed in acpi-cpufreq driver. This patch adds a comment
> describing why we need to set policy->cur from driver.
> 
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> This change was requested by Rafael here:
> http://www.spinics.net/lists/linux-acpi/msg46748.html
> 
>  drivers/cpufreq/acpi-cpufreq.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index a8dac7b..8ecd74e 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -838,6 +838,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  	switch (perf->control_register.space_id) {
>  	case ACPI_ADR_SPACE_SYSTEM_IO:
>  		/* Current speed is unknown and not detectable by IO port */
> +		/* ->cur wouldn't be set by core as ->get() is NULL */

Well, please merge it with the existing comment and use the usual format for
comments that are longer than two lines.

>  		policy->cur = acpi_cpufreq_guess_freq(data, policy->cpu);
>  		break;
>  	case ACPI_ADR_SPACE_FIXED_HARDWARE:
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
