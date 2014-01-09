Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaAIKp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:45:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42628 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbaAIKpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:45:50 -0500
Date: Thu, 9 Jan 2014 10:45:20 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/7] ARM: perf_event: Silence sparse warning
Message-ID: <20140109104519.GA17838@mudshark.cambridge.arm.com>
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
 <1389221984-10973-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389221984-10973-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Jan 08, 2014 at 10:59:38PM +0000, Stephen Boyd wrote:
> arch/arm/kernel/perf_event_cpu.c:274:25: warning: incorrect type in assignment (different modifiers)
> arch/arm/kernel/perf_event_cpu.c:274:25: expected int ( *init_fn )( ... )
> arch/arm/kernel/perf_event_cpu.c:274:25: got void const *const data
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Given that the rest of the series depends on the change to the percpu IRQ
stuff, I think you can just send this patch to Russell's patch system with
my ack:

  Acked-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will

>  arch/arm/kernel/perf_event_cpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> index d85055cd24ba..20d553c9f5e2 100644
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@ -254,7 +254,7 @@ static int probe_current_pmu(struct arm_pmu *pmu)
>  static int cpu_pmu_device_probe(struct platform_device *pdev)
>  {
>  	const struct of_device_id *of_id;
> -	int (*init_fn)(struct arm_pmu *);
> +	const int (*init_fn)(struct arm_pmu *);
>  	struct device_node *node = pdev->dev.of_node;
>  	struct arm_pmu *pmu;
>  	int ret = -ENODEV;
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
