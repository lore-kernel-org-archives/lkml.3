Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaKMDZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 22:25:42 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58266 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaKMDZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 22:25:41 -0500
Message-ID: <546424B1.6070205@amacapital.net>
Date: Wed, 12 Nov 2014 19:25:37 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
CC: H Peter Anvin <h.peter.anvin@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, x86@kernel.org
Subject: Re: [PATCH 1/6] x86: Add support for the pcommit instruction
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com> <1415731396-19364-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1415731396-19364-2-git-send-email-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 10:43 AM, Ross Zwisler wrote:
> Add support for the new pcommit instruction.  This instruction was
> announced in the document "Intel Architecture Instruction Set Extensions
> Programming Reference" with reference number 319433-022.
> 
> https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: H Peter Anvin <h.peter.anvin@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: x86@kernel.org
> ---
>  arch/x86/include/asm/cpufeature.h    | 1 +
>  arch/x86/include/asm/special_insns.h | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 0bb1335..b3e6b89 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -225,6 +225,7 @@
>  #define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
>  #define X86_FEATURE_ADX		( 9*32+19) /* The ADCX and ADOX instructions */
>  #define X86_FEATURE_SMAP	( 9*32+20) /* Supervisor Mode Access Prevention */
> +#define X86_FEATURE_PCOMMIT	( 9*32+22) /* PCOMMIT instruction */
>  #define X86_FEATURE_CLFLUSHOPT	( 9*32+23) /* CLFLUSHOPT instruction */
>  #define X86_FEATURE_AVX512PF	( 9*32+26) /* AVX-512 Prefetch */
>  #define X86_FEATURE_AVX512ER	( 9*32+27) /* AVX-512 Exponential and Reciprocal */
> diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> index e820c08..1709a2e 100644
> --- a/arch/x86/include/asm/special_insns.h
> +++ b/arch/x86/include/asm/special_insns.h
> @@ -199,6 +199,12 @@ static inline void clflushopt(volatile void *__p)
>  		       "+m" (*(volatile char __force *)__p));
>  }
>  
> +static inline void pcommit(void)
> +{
> +	alternative(ASM_NOP4, ".byte 0x66, 0x0f, 0xae, 0xf8",
> +		    X86_FEATURE_PCOMMIT);
> +}
> +

Should this patch add the feature bit and cpuinfo entry to go with it?

--Andy
