Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaGIOix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:38:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39184 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaGIOiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:38:51 -0400
Message-ID: <53BD53EA.8050708@ti.com>
Date: Wed, 9 Jul 2014 10:38:34 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>,
        <shawn.guo@linaro.org>
CC: <nm@ti.com>, <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <t.figa@samsung.com>,
        <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <thomas.ab@samsung.com>, <arvind.chauhan@arm.com>,
        <spk.linux@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 02/14] clk: Create of_clk_shared_by_cpus()
References: <cover.1404231535.git.viresh.kumar@linaro.org> <5f7164d789e87c62d722b575980c92dfd0504334.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <5f7164d789e87c62d722b575980c92dfd0504334.1404231535.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Lorenzo

On Tuesday 01 July 2014 12:32 PM, Viresh Kumar wrote:
> Create a new routine of_clk_shared_by_cpus() that finds if clock lines are
> shared between two CPUs. This is verified by comparing "clocks" property from
> CPU's DT node.
> 
> Returns 1 if clock line is shared between them, 0 if clock isn't shared and
> return appropriate errors in case nodes/properties are missing.
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/clk/clk.c   | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clk.h |  6 ++++++
>  2 files changed, 62 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 8b73ede..497735c 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/clk-private.h>
> +#include <linux/cpu.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> @@ -2528,6 +2529,61 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
>  }
>  EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
>  
> +/**
> + * of_clk_shared_by_cpus - Finds if clock line is shared between CPUs
> + * @cpu1, cpu2: CPU numbers
> + *
> + * Finds if clock lines are shared by two CPUs. This is verified by comparing
> + * "clocks" property from CPU's DT node.
> + *
> + * Returns 1 if clock line is shared between them, 0 if clock isn't shared.
> + * Return appropriate errors in case some requirements aren't met.
> + */
> +int of_clk_shared_by_cpus(int cpu1, int cpu2)

I might be wrong but this API seems to bit short cited. We should probably
handle it bit better since there are more cases instead of just checking CPU
tuple. More than two CPUs may share the clock so discovering that in one iteration
is better. I also think this is closely related to CPU topology.

- CPUs part of 'a cluster' shares same clock.
- Multiple clusters may share same clock
- Every CPU might be clocked from separate PLL.

What you say ?

Regards,
Santosh




