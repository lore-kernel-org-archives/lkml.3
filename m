Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab3CZNa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:30:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43096 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705Ab3CZNaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:30:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, dirk.j.brandewie@intel.com
Subject: Re: [PATCH] intel-pstate: Use #defines instead of hard-coded values.
Date: Tue, 26 Mar 2013 14:37:51 +0100
Message-ID: <13252849.uMIDiVUCkC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1363789270-29579-1-git-send-email-konrad.wilk@oracle.com>
References: <1363789270-29579-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 20, 2013 10:21:10 AM Konrad Rzeszutek Wilk wrote:
> They are defined in coreboot (MSR_PLATFORM) and the other
> one is already defined in msr-index.h.
> 
> Lets use those.
> 
> CC: rafael.j.wysocki@intel.com
> CC: dirk.j.brandewie@intel.com
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Applied.

Thanks,
Rafael


> ---
>  arch/x86/include/uapi/asm/msr-index.h | 1 +
>  drivers/cpufreq/intel_pstate.c        | 6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index 892ce40..7a060f4 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -44,6 +44,7 @@
>  #define SNB_C1_AUTO_UNDEMOTE		(1UL << 27)
>  #define SNB_C3_AUTO_UNDEMOTE		(1UL << 28)
>  
> +#define MSR_PLATFORM_INFO		0x000000ce
>  #define MSR_MTRRcap			0x000000fe
>  #define MSR_IA32_BBL_CR_CTL		0x00000119
>  #define MSR_IA32_BBL_CR_CTL3		0x0000011e
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index f6dd1e7..dadc27d 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -358,14 +358,14 @@ static void intel_pstate_sysfs_expose_params(void)
>  static int intel_pstate_min_pstate(void)
>  {
>  	u64 value;
> -	rdmsrl(0xCE, value);
> +	rdmsrl(MSR_PLATFORM_INFO, value);
>  	return (value >> 40) & 0xFF;
>  }
>  
>  static int intel_pstate_max_pstate(void)
>  {
>  	u64 value;
> -	rdmsrl(0xCE, value);
> +	rdmsrl(MSR_PLATFORM_INFO, value);
>  	return (value >> 8) & 0xFF;
>  }
>  
> @@ -373,7 +373,7 @@ static int intel_pstate_turbo_pstate(void)
>  {
>  	u64 value;
>  	int nont, ret;
> -	rdmsrl(0x1AD, value);
> +	rdmsrl(MSR_NHM_TURBO_RATIO_LIMIT, value);
>  	nont = intel_pstate_max_pstate();
>  	ret = ((value) & 255);
>  	if (ret <= nont)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
