Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab3HZEmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 00:42:36 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:52009 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3HZEme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 00:42:34 -0400
MIME-Version: 1.0
In-Reply-To: <1377299755-5134-2-git-send-email-eduardo.valentin@ti.com>
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
	<1377299755-5134-2-git-send-email-eduardo.valentin@ti.com>
Date: Mon, 26 Aug 2013 10:12:33 +0530
Message-ID: <CAKohpomuFWyH6ss4_L-0j9WyXtsZEygWrFLYXE6Oj_AD-DJUjA@mail.gmail.com>
Subject: Re: [RFC PATCH 01/14] cpufreq: cpufreq-cpu0: add dt node parsing for 'cooling-zones'
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>, Zhang Rui <rui.zhang@intel.com>,
        wni@nvidia.com, "R, Durgadoss" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lm-sensors@lm-sensors.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 August 2013 04:45, Eduardo Valentin <eduardo.valentin@ti.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index ad1fde2..ede6487 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -20,6 +20,9 @@
>  #include <linux/platform_device.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
> +#include <linux/thermal.h>
> +#include <linux/cpu_cooling.h>
> +#include <linux/cpumask.h>

In alphabetical order please..

> @@ -268,6 +272,13 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>                 goto out_free_table;
>         }
>
> +       /*
> +        * For now, just loading the cooling device;
> +        * thermal DT code takes care of matching them.
> +        */
> +       if (of_find_property(np, "cooling-zones", NULL))
> +               cdev = cpufreq_cooling_register(cpu_present_mask);

Should we check if it passed or failed? And if failed Atleast flag an
appropriate message?
