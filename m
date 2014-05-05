Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbaEEOXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:23:18 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:59943 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795AbaEEOXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:23:15 -0400
MIME-Version: 1.0
In-Reply-To: <1399296830-13056-2-git-send-email-nm@ti.com>
References: <1399296830-13056-1-git-send-email-nm@ti.com>
	<1399296830-13056-2-git-send-email-nm@ti.com>
Date: Mon, 5 May 2014 19:53:14 +0530
Message-ID: <CAKohpomeP3Ftx8mH=x0Hj7HEpw6A9X8O8JEFqvrJbkZYDqDS6Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM / OPP: Remove cpufreq wrapper dependency on
 internal data organization
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 May 2014 19:03, Nishanth Menon <nm@ti.com> wrote:
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>  int dev_pm_opp_init_cpufreq_table(struct device *dev,
>                             struct cpufreq_frequency_table **table)
>  {
> -       struct device_opp *dev_opp;
>         struct dev_pm_opp *opp;
> -       struct cpufreq_frequency_table *freq_table;
> -       int i = 0;
> +       struct cpufreq_frequency_table *freq_table = NULL;
> +       int i, max_opps, ret = 0;
> +       unsigned long rate;
>
> -       /* Pretend as if I am an updater */
> -       mutex_lock(&dev_opp_list_lock);

What if opp is being added for some reason at the same time?
I hope we can surely see some awkward results, maybe some
NULL pointers invocations as well..
