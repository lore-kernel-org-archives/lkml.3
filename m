Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaGIHtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:49:49 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34609 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGIHtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:49:47 -0400
MIME-Version: 1.0
In-Reply-To: <1404144343-18720-6-git-send-email-vincent.guittot@linaro.org>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
	<1404144343-18720-6-git-send-email-vincent.guittot@linaro.org>
Date: Wed, 9 Jul 2014 09:49:46 +0200
Message-ID: <CAP245DWoQEgotq1FAu9f=zk_-bXAQtnG-RfLWzjrmOoZaCkBDw@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] ARM: topology: use new cpu_power interface
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lists LAKML <linux-arm-kernel@lists.infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 6:05 PM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
> Use the new arch_scale_cpu_power in order to reflect the original capacity of

s/arch_scale_cpu_power/arch_scale_cpu_capacity and similar renames in
the commit logs across the entire patchset to take into account all
the renames in the code.

> a CPU instead of arch_scale_freq_power which is more linked to a scaling of
> the capacity linked to the frequency.

here too...

> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  arch/arm/kernel/topology.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index d42a7db..2310bfb 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -42,7 +42,7 @@
>   */
>  static DEFINE_PER_CPU(unsigned long, cpu_scale);
>
> -unsigned long arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
> +unsigned long arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
>  {
>         return per_cpu(cpu_scale, cpu);
>  }
> @@ -166,7 +166,7 @@ static void update_cpu_capacity(unsigned int cpu)
>         set_capacity_scale(cpu, cpu_capacity(cpu) / middle_capacity);
>
>         printk(KERN_INFO "CPU%u: update cpu_capacity %lu\n",
> -               cpu, arch_scale_freq_capacity(NULL, cpu));
> +               cpu, arch_scale_cpu_capacity(NULL, cpu));
>  }
>
>  #else
> --
> 1.9.1
>
>
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel
