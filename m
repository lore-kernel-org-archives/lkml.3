Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3F1XxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:53:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39852 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3F1XxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:53:10 -0400
Date: Sat, 29 Jun 2013 00:53:07 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 095/105] ARM: 7762/1: kernel: fix arm_dt_init_cpu_maps()
 to skip non-cpu nodes
Message-ID: <20130628235307.GB15316@e102568-lin.cambridge.arm.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
 <1372445527-24414-96-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
In-Reply-To: <1372445527-24414-96-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 28 Jun 2013 23:53:07.0913 (UTC) FILETIME=[A37DC390:01CE745A]
X-MC-Unique: 113062900530800201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 07:51:57PM +0100, Kamal Mostafa wrote:
> 3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

Owing to dependencies on other patches getting upstreamed but not
necessarily backported to stable, waiting for a decision on how to solve
dependencies to be made asap, please drop this patch from the queue since
it can trigger regressions.

Thanks and apologies,
Lorenzo

> 
> ------------------
> 
> From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> 
> commit 1ba9bf0a9ae779c1a2b3eb64951e4161d9bad7a9 upstream.
> 
> The introduction of the cpu-map topology node in the cpus node implies
> that cpus node might have children that are not cpu nodes. The DT
> parsing code needs updating otherwise it would check for cpu nodes
> properties in nodes that are not required to contain them, resulting
> in warnings that have no bearing on bindings defined in the dts source file.
> 
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  arch/arm/kernel/devtree.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index 70f1bde..93fde23 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -92,6 +92,9 @@ void __init arm_dt_init_cpu_maps(void)
>  	for_each_child_of_node(cpus, cpu) {
>  		u32 hwid;
>  
> +		if (of_node_cmp(cpu->type, "cpu"))
> +			continue;
> +
>  		pr_debug(" * %s...\n", cpu->full_name);
>  		/*
>  		 * A device tree containing CPU nodes with missing "reg"
> -- 
> 1.8.1.2
> 
> 

