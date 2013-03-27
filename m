Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3C0Wlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:41:37 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:9686 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356Ab3C0Wle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:41:34 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCCD5-01-40M-02
X-M-MSG: 
Date: Wed, 27 Mar 2013 17:41:22 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130327224122.GA15786@jshin-Toonie>
References: <1364423841-6920-1-git-send-email-jacob.shin@amd.com>
 <1364423841-6920-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1364423841-6920-3-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:37:21PM -0500, Jacob Shin wrote:
> Future AMD processors, starting with Family 16h, can provide software
> with feedback on how the workload may respond to frequency change --
> memory-bound workloads will not benefit from higher frequency, where
> as compute-bound workloads will. This patch enables this "frequency
> sensitivity feedback" to aid the ondemand governor to make better
> frequency change decisions by hooking into the powersave bias.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/include/uapi/asm/msr-index.h |    1 +
>  drivers/cpufreq/Kconfig.x86           |   10 ++++++++++
>  drivers/cpufreq/Makefile              |    1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index 7a060f4..b2e6c49 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -173,6 +173,7 @@
>  #define MSR_AMD64_TSC_RATIO		0xc0000104
>  #define MSR_AMD64_NB_CFG		0xc001001f
>  #define MSR_AMD64_PATCH_LOADER		0xc0010020
> +#define MSR_AMD64_FREQ_SENSITIVITY	0xc0010080
>  #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
>  #define MSR_AMD64_OSVW_STATUS		0xc0010141
>  #define MSR_AMD64_DC_CFG		0xc0011022
> diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
> index d7dc0ed..6c714b0 100644
> --- a/drivers/cpufreq/Kconfig.x86
> +++ b/drivers/cpufreq/Kconfig.x86
> @@ -129,6 +129,16 @@ config X86_POWERNOW_K8
>  
>  	  For details, take a look at <file:Documentation/cpu-freq/>.
>  
> +config X86_AMD_FREQ_SENSITIVITY
> +	tristate "AMD 'frequency sensitivity feedback' powersave bias"
> +	depends on CPU_FREQ_GOV_ONDEMAND && X86_ACPI_CPUFREQ
> +	help
> +	  This adds support for 'frequency sensitivity feedback' feature on
> +	  supported AMD processors, which hooks into the ondemand governor's
> +	  powersave bias to influence frequency change decisions.
> +
> +	  If in doubt, say N.
> +
>  config X86_GX_SUSPMOD
>  	tristate "Cyrix MediaGX/NatSemi Geode Suspend Modulation"
>  	depends on X86_32 && PCI
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index 863fd18..01dfdaf 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -41,6 +41,7 @@ obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO)	+= speedstep-centrino.o
>  obj-$(CONFIG_X86_P4_CLOCKMOD)		+= p4-clockmod.o
>  obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
>  obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pstate.o
> +obj-$(CONFIG_X86_AMD_FREQ_SENSITIVITY)	+= amd_freq_sensitivity.o

So sorry .. this file did not get git add'ed. Will resend in a bit

>  
>  ##################################################################################
>  # ARM SoC drivers
> -- 
> 1.7.9.5
> 

