Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaCWBxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 21:53:46 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46512 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaCWBxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 21:53:45 -0400
Message-ID: <532E3DB4.9060908@linux.vnet.ibm.com>
Date: Sun, 23 Mar 2014 07:19:40 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        dietmar.eggemann@arm.com, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v3 6/6] sched: powerpc: Add SD_SHARE_POWERDOMAIN for SMT
 level
References: <1395246165-31150-1-git-send-email-vincent.guittot@linaro.org> <1395246165-31150-7-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1395246165-31150-7-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032301-4790-0000-0000-000000487DD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On 03/19/2014 09:52 PM, Vincent Guittot wrote:
> Set the power domain dependency at SMT level of Power8 but keep the flag
> clear at CPU level. The goal is to consolidate tasks on the threads of a
> core up to a level as explained by Preeti:
> "On powerpc we would want to clear the SD_SHARE_POWERDOMAIN flag at the CPU
> domain. On Power8, considering we have 8 threads per core, we would want to
> consolidate tasks atleast upto 4 threads without significant performance
> impact before spilling over to the other cores. By doing so, besides making
> use of the higher power of the core we could do cpuidle management at the
> core level for the remaining idle cores as a result of this consolidation."
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

We were discussing the impact of this consolidation and we are not too
sure if it will yield us good power efficiency. So we would want to
experiment with the power aware scheduler to find the "sweet spot" for
the number of threads to consolidate to and more importantly if there is
one such number at all. Else we would not want to go this way at all.
Hence it looks best if this patch is dropped until we validate it. We
don't want the code getting in and then out if we find out later there
are no benefits to it.

I am sorry that I suggested this patch a bit pre-mature in the
experimentation and validation stage. When you release the load
balancing patchset for power aware scheduler I shall validate this
patch. But until then its best if it does not get merged.

Thanks

Regards
Preeti U Murthy
> ---
>  arch/powerpc/kernel/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index c9cade5..fbbac3c 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -759,7 +759,7 @@ int setup_profiling_timer(unsigned int multiplier)
>  /* cpumask of CPUs with asymetric SMT dependancy */
>  static const int powerpc_smt_flags(void)
>  {
> -	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
> +	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN;
> 
>  	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
>  		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
> 

