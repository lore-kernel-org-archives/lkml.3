Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965587AbaFRJ5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:57:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52563 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964994AbaFRJ5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:57:43 -0400
Date: Wed, 18 Jun 2014 11:57:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
Message-ID: <20140618095739.GA24419@pd.tnic>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 05:44:09PM +0800, Qiaowei Ren wrote:
> In order to do performance optimization, this patch adds macro
> cpu_has_mpx which will directly return 0 when MPX is not supported
> by kernel.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  arch/x86/include/asm/cpufeature.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index e265ff9..f302d08 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -339,6 +339,12 @@ extern const char * const x86_power_flags[32];
>  #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
>  #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
>  
> +#ifdef CONFIG_X86_INTEL_MPX
> +#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX)

I think we don't want those macros anymore because they're obfuscating
the code. You should use static_cpu_has instead.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
