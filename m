Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaGBJPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:15:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65412 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbaGBJPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:15:22 -0400
Date: Wed, 2 Jul 2014 10:15:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: linux-next: manual merge of the arm-perf tree with the arm tree
Message-ID: <20140702091519.GB18731@arm.com>
References: <20140702111708.0a209b87@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702111708.0a209b87@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 02:17:08AM +0100, Stephen Rothwell wrote:
> Hi Will,

Hi Stephen,

> Today's linux-next merge of the arm-perf tree got a conflict in
> arch/arm/kernel/perf_event_cpu.c between commit 324bbc0804ac ("ARM:
> make it easier to check the CPU part number correctly") from the arm
> tree and commit 6f73e8ababdd ("arm: perf: clean up PMU names") from the
> arm-perf tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

Russell -- could you put your CPU part number patches on a stable branch
please? That way I can send you a pull request based on that (or you can fix
the conflicts up yourself, just let me know what you prefer).

Will

> diff --cc arch/arm/kernel/perf_event_cpu.c
> index c02c2e8c877d,c63dc4201a7f..000000000000
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@@ -254,35 -259,38 +257,39 @@@ static int probe_current_pmu(struct arm
>   
>   	pr_info("probing PMU on CPU %d\n", cpu);
>   
>  +	switch (read_cpuid_part()) {
>   	/* ARM Ltd CPUs. */
>  -	if (implementor == ARM_CPU_IMP_ARM) {
>  -		switch (part_number) {
>  -		case ARM_CPU_PART_ARM1136:
>  -			ret = armv6_1136_pmu_init(pmu);
>  -			break;
>  -		case ARM_CPU_PART_ARM1156:
>  -			ret = armv6_1156_pmu_init(pmu);
>  -			break;
>  -		case ARM_CPU_PART_ARM1176:
>  -			ret = armv6_1176_pmu_init(pmu);
>  -			break;
>  -		case ARM_CPU_PART_ARM11MPCORE:
>  -			ret = armv6mpcore_pmu_init(pmu);
>  -			break;
>  -		case ARM_CPU_PART_CORTEX_A8:
>  -			ret = armv7_a8_pmu_init(pmu);
>  -			break;
>  -		case ARM_CPU_PART_CORTEX_A9:
>  -			ret = armv7_a9_pmu_init(pmu);
>  -			break;
>  -		}
>  -	/* Intel CPUs [xscale]. */
>  -	} else if (implementor == ARM_CPU_IMP_INTEL) {
>  -		switch (xscale_cpu_arch_version()) {
>  -		case ARM_CPU_XSCALE_ARCH_V1:
>  -			ret = xscale1pmu_init(pmu);
>  -			break;
>  -		case ARM_CPU_XSCALE_ARCH_V2:
>  -			ret = xscale2pmu_init(pmu);
>  -			break;
>  +	case ARM_CPU_PART_ARM1136:
> ++		ret = armv6_1136_pmu_init(pmu);
> ++		break;
>  +	case ARM_CPU_PART_ARM1156:
> ++		ret = armv6_1156_pmu_init(pmu);
> ++		break;
>  +	case ARM_CPU_PART_ARM1176:
> - 		ret = armv6pmu_init(pmu);
> ++		ret = armv6_1176_pmu_init(pmu);
>  +		break;
>  +	case ARM_CPU_PART_ARM11MPCORE:
>  +		ret = armv6mpcore_pmu_init(pmu);
>  +		break;
>  +	case ARM_CPU_PART_CORTEX_A8:
>  +		ret = armv7_a8_pmu_init(pmu);
>  +		break;
>  +	case ARM_CPU_PART_CORTEX_A9:
>  +		ret = armv7_a9_pmu_init(pmu);
>  +		break;
>  +
>  +	default:
>  +		if (read_cpuid_implementor() == ARM_CPU_IMP_INTEL) {
>  +			switch (xscale_cpu_arch_version()) {
>  +			case ARM_CPU_XSCALE_ARCH_V1:
>  +				ret = xscale1pmu_init(pmu);
>  +				break;
>  +			case ARM_CPU_XSCALE_ARCH_V2:
>  +				ret = xscale2pmu_init(pmu);
>  +				break;
>  +			}
>   		}
>  +		break;
>   	}
>   
>   	put_cpu();


