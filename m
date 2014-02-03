Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaBCUbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:31:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35712 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaBCUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:31:50 -0500
Message-ID: <52EFFCB3.1020208@codeaurora.org>
Date: Mon, 03 Feb 2014 15:31:47 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/7] ARM: perf_event: Support percpu irqs for the CPU
 PMU
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org> <1389808535-23852-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1389808535-23852-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 12:55 PM, Stephen Boyd wrote:
> Some CPU PMUs are wired up with one PPI for all the CPUs instead
> of with a different SPI for each CPU. Add support for these
> devices.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/kernel/perf_event.c     | 14 ++++--
>  arch/arm/kernel/perf_event_cpu.c | 97 ++++++++++++++++++++++++++++------------
>  2 files changed, 80 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 789d846a9184..e76750980b38 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -16,6 +16,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/uaccess.h>
> +#include <linux/irq.h>
> +#include <linux/irqdesc.h>
>  
>  #include <asm/irq_regs.h>
>  #include <asm/pmu.h>
> @@ -295,9 +297,15 @@ validate_group(struct perf_event *event)
>  
>  static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
>  {
> -	struct arm_pmu *armpmu = (struct arm_pmu *) dev;
> -	struct platform_device *plat_device = armpmu->plat_device;
> -	struct arm_pmu_platdata *plat = dev_get_platdata(&plat_device->dev);
> +	struct arm_pmu *armpmu;
> +	struct platform_device *plat_device;
> +	struct arm_pmu_platdata *plat;
> +
> +	if (irq_is_percpu(irq))

In case anyone else is trying to follow along, this requires:

http://lkml.org/lkml/2013/12/4/316

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
