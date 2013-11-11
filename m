Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3KKPpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:45:44 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23674 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3KKPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:45:35 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-93-5280fb9c5672
Message-id: <5280FB9A.7030500@samsung.com>
Date: Mon, 11 Nov 2013 19:45:30 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Naour Romain <romain.naour@openwide.fr>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3 3/4] ARM: EXYNOS: add Exynos Dual Cluster Support
References: <20131108184036.GD2602@localhost.localdomain>
 <alpine.LFD.2.03.1311081356300.15571@syhkavp.arg>
 <52808E09.9060902@samsung.com>
In-reply-to: <52808E09.9060902@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t/xa7pzfjcEGey9qGwxad0BJot5n2Ut
	mubuYbSYf+Qcq8X/R69ZLc69Wslo0bvgKpvFpsfXWC0Wti1hsbi8aw6bxYzz+5gsbl/mtVh6
	/SKTxdMJF9ksPj37x24xYfpaFovDK4CmrXs5ncViy88ORotXB9tYLDZvmspssWrXH0aLqTN+
	sDuIe6yZt4bRo6W5h81jwecr7B5/V71g9tg56y67x8rlX9g8Xq2eyepx59oeNo93586xe2xe
	Uu/x6hqLR9+WVYwe26/NY/b4vEnOY+Pc0AD+KC6blNSczLLUIn27BK6M7Z+aWQruyVc09r1m
	bWC8KNbFyMkhIWAice7vJRYIW0ziwr31bCC2kMBSRomX5zK7GLmA7PeMErO+72cFSfAKaEls
	u3GOCcRmEVCVmHtgJlADBwebgLbElh1eIGFRgQiJo6ufQZULSvyYfA9svoiAv8SdKWtYQGYy
	Czxnl9i5YAVYQljAQ+LkrMusEMv6GCX+XXkGluAEGvp78nOwi5gFrCVWTtrGCGHLS2xe85Z5
	AqPALCRLZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkAj/uoNx6TGrQ4wC
	HIxKPLwMcg1BQqyJZcWVuYcYJTiYlUR4PxwHCvGmJFZWpRblxxeV5qQWH2Jk4uCUamDsbcxX
	eb3bZPObKGGD5Vqrj/zNX37HVob5wHTPtSHM9o+V7O/qdIRptgqcsVv4vI+3+5fV3keTP8om
	Xlyhv8zSav0NtiO96Yd3v5eO+Xcwt32jool7gPENfSb5d1ebTyh9/dlzKf/GN/Vd+xgFa9bV
	hkxTmlFlZtp5TpLDfG4Fk5/TNLXXs/4qsRRnJBpqMRcVJwIAQh1uYc4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11.11.2013 11:58, Tarek Dakhran wrote:
>
>> On Thu, Nov 07, 2013 at 11:51:49AM -0500, Nicolas Pitre wrote:
>> Samsung people: could you give us more info on the behavior of the power
>> controller please?
>>
>>
>> Nicolas
>>
> This is how the power controller works on exynos5410. For example for 
> CORE0.
>
> ARM_CORE0_STATUS register indicates the power state of Core 0 part of 
> processor core.
> 0x3 indicates that power to Core 0 is turned-on. 0x0 indicates that 
> power to Core 0 is turned-off.
> All other values indicate that the power On/Off sequence of Core 0 in 
> progress.
>
> To turn Off the power of Core 0 power domain:
>
> 1. Set the LOCAL_POWER_CFG field of ARM_CORE0_CONFIGURATION register 
> to 0x3.
> 2. After PMU detects a change in the LOCAL_POWER_CFG field, it waits 
> for the execution of WFI.
> 3. After Core 0 executes the WFI instruction, PMU starts the 
> power-down sequence.
> 4. The Status field of ARM_CORE0_STATUS register indicates the 
> completion of the sequence.
>
> That's why in the v1 of this patch exynos_core_power_control function 
> was implemented as:
>
> static int exynos_core_power_control(unsigned int cpu, unsigned int 
> cluster,  int enable)
> {
>        unsigned long timeout = jiffies + msecs_to_jiffies(10);
>        unsigned int offset = cluster * MAX_CPUS_PER_CLUSTER + cpu;
>        int value = enable ? S5P_CORE_LOCAL_PWR_EN : 0;
>
>        if ((__raw_readl(EXYNOS5410_CORE_STATUS(offset)) & 0x3) == value)
>                return 0;
>
>        __raw_writel(value, EXYNOS5410_CORE_CONFIGURATION(offset));
>        do {
>                if ((__raw_readl(EXYNOS5410_CORE_STATUS(offset)) & 0x3)
>                                == value)
>                        return 0;
>        } while (time_before(jiffies, timeout));
>
>        return -EDEADLK;
> }
>
> But, as i mentioned, this is no good using while here.
> Now thinking about the problem.
>
> Thank you,
>         Tarek Dakhran

What do you think about this way of solving the problem with races?

Add new edcs_power_controller_wait function.

static void edcs_power_controller_wait(unsigned int cpu, unsigned int 
cluster){

         unsigned long timeout = jiffies + msecs_to_jiffies(10);
         unsigned int offset = cluster * EDCS_CPUS_PER_CLUSTER + cpu;
         void __iomem *status_reg = EDCS_CORE_STATUS(offset);

         /* wait till core power controller finish the work */

         do {
                 if ((readl_relaxed(status_reg) & 3) == 
edcs_use_count[cpu][cluster] ? 3 : 0)
                         return;
         } while (time_before(jiffies, timeout));

         /* Should never get here */
         BUG();
}

Use it in:

static void exynos_core_power_up(unsigned int cpu, unsigned int cluster)
{
         exynos_core_power_control(cpu, cluster, true);
         edcs_power_controller_wait(cpu, cluster);
}

and in:

static void exynos_power_down(void)
{
         bool last_man = false, skip_wfi = false;
         unsigned int mpidr = read_cpuid_mpidr();
         unsigned int cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
         unsigned int cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);


         pr_debug("%s: CORE%d on CLUSTER %d\n", __func__, cpu, cluster);
         BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER  || cluster >= EDCS_CLUSTERS);

         __mcpm_cpu_going_down(cpu, cluster);

         arch_spin_lock(&edcs_lock);
         BUG_ON(__mcpm_cluster_state(cluster) != CLUSTER_UP);
         edcs_use_count[cpu][cluster]--;
         if (edcs_use_count[cpu][cluster] == 0) {
                 exynos_core_power_down(cpu, cluster);
                 --core_count[cluster];
                 if (core_count[cluster] == 0)
                         last_man = true;
[snip]
         __mcpm_cpu_down(cpu, cluster);

         if (!skip_wfi){
                 wfi();
         }
         edcs_power_controller_wait(cpu, cluster);
}

Comments appreciated. Thanks.

Best regards,
     Tarek Dakhran.
