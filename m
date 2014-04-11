Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaDKSbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:31:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55091 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaDKSbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:31:47 -0400
Message-ID: <53483511.4000100@codeaurora.org>
Date: Fri, 11 Apr 2014 11:31:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>
CC: will.deacon@arm.com, linux@arm.linux.org.uk,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: perf: save/restore pmu registers in pm notifier
References: <1397214083-30916-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1397214083-30916-1-git-send-email-zhangwm@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/14 04:01, Neil Zhang wrote:
> @@ -217,6 +219,24 @@ static struct notifier_block cpu_pmu_hotplug_notifier = {
>  	.notifier_call = cpu_pmu_notify,
>  };
>  
> +static int cpu_pmu_pm_notify(struct notifier_block *b,
> +					unsigned long action, void *hcpu)
> +{
> +	int cpu = smp_processor_id();
> +	struct cpupmu_regs *pmuregs = &per_cpu(cpu_pmu_regs, cpu);

this_cpu_ptr(&cpu_pmu_regs)?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

