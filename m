Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaFPHtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:49:41 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:55584 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaFPHtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:49:39 -0400
MIME-Version: 1.0
In-Reply-To: <539C17BB.1020809@acm.org>
References: <539C17BB.1020809@acm.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 16 Jun 2014 09:49:19 +0200
Message-ID: <CAKfTPtBLSHYCdUpdN6MZiD_gCLa12Gv-hMO5oRY6uyiw4AqCug@mail.gmail.com>
Subject: Re: [PATCH] Suppress -Wignored-qualifiers warnings
To: Bart Van Assche <bvanassche@acm.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

Guenter sent similar patch few days ago
https://lkml.org/lkml/2014/6/12/743
with additional patches for ARM and powerpc architecture
https://lkml.org/lkml/2014/6/13/399
https://lkml.org/lkml/2014/6/13/407

Vincent


On 14 June 2014 11:36, Bart Van Assche <bvanassche@acm.org> wrote:
> Avoid that gcc reports the following warning when building with W=1:
>
> warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  include/linux/sched.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 306f4f0..0376b05 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -872,21 +872,21 @@ enum cpu_idle_type {
>  #define SD_NUMA                        0x4000  /* cross-node balancing */
>
>  #ifdef CONFIG_SCHED_SMT
> -static inline const int cpu_smt_flags(void)
> +static inline int cpu_smt_flags(void)
>  {
>         return SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
>  }
>  #endif
>
>  #ifdef CONFIG_SCHED_MC
> -static inline const int cpu_core_flags(void)
> +static inline int cpu_core_flags(void)
>  {
>         return SD_SHARE_PKG_RESOURCES;
>  }
>  #endif
>
>  #ifdef CONFIG_NUMA
> -static inline const int cpu_numa_flags(void)
> +static inline int cpu_numa_flags(void)
>  {
>         return SD_NUMA;
>  }
> @@ -999,7 +999,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
>  bool cpus_share_cache(int this_cpu, int that_cpu);
>
>  typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
> -typedef const int (*sched_domain_flags_f)(void);
> +typedef int (*sched_domain_flags_f)(void);
>
>  #define SDTL_OVERLAP   0x01
>
> --
> 1.8.4.5
>
