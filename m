Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbaCEUdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:33:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36159 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaCEUdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:33:10 -0500
Message-ID: <53178A03.3090004@codeaurora.org>
Date: Wed, 05 Mar 2014 12:33:07 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?SsO8cmcgQmlsbGV0ZXI=?= <j@bitron.ch>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@lists.codethink.co.uk,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH] ARM: kernel: respect device tree status of cpu nodes
References: <1393240960-31846-1-git-send-email-j@bitron.ch>
In-Reply-To: <1393240960-31846-1-git-send-email-j@bitron.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Lorenzo

On 02/24/14 03:22, Jürg Billeter wrote:
> Skip 'disabled' cpu nodes when building the cpu logical map. This avoids
> booting cpus that have been disabled in the device tree.
>
> Signed-off-by: Jürg Billeter <j@bitron.ch>
> Reviewed-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  arch/arm/kernel/devtree.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index 739c3df..9aed299 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -95,6 +95,10 @@ void __init arm_dt_init_cpu_maps(void)
>  		if (of_node_cmp(cpu->type, "cpu"))
>  			continue;
>  
> +		/* Check if CPU is enabled */
> +		if (!of_device_is_available(cpu))
> +			continue;
> +
>  		pr_debug(" * %s...\n", cpu->full_name);
>  		/*
>  		 * A device tree containing CPU nodes with missing "reg"

This doesn't follow the ePAPR spec. According to ePAPR status="disabled"
in a cpu node means "the cpu is in a quiescent state" and one can enable
it by using the "enable-method". At the least, we should document this
in bindings/arm/cpus.txt if we can all agree that we want this
definition of disabled.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

