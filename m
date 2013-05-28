Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341Ab3E1O2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:28:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48033 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934269Ab3E1O2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:28:18 -0400
Date: Tue, 28 May 2013 16:28:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/3] x86/microcode: vendor abstract out
 save_microcode_in_initrd()
Message-ID: <20130528142814.GB29233@pd.tnic>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
 <1369323618-5820-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369323618-5820-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:40:16AM -0500, Jacob Shin wrote:
> Currently save_microcode_in_initrd() is declared in vendor neutural
> microcode.h file, but defined in vendor specific
> microcode_intel_early.c file. Vendor abstract it out to
> microcode_core_early.c with a wrapper function.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/include/asm/microcode_intel.h  |    5 +++++
>  arch/x86/kernel/microcode_core_early.c  |   10 ++++++++++
>  arch/x86/kernel/microcode_intel_early.c |    2 +-
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
> index 5356f92..538e407 100644
> --- a/arch/x86/include/asm/microcode_intel.h
> +++ b/arch/x86/include/asm/microcode_intel.h
> @@ -67,10 +67,15 @@ update_match_revision(struct microcode_header_intel *mc_header, int rev);
>  extern void __init load_ucode_intel_bsp(void);
>  extern void __cpuinit load_ucode_intel_ap(void);
>  extern void show_ucode_info_early(void);
> +extern int __init save_microcode_in_initrd_intel(void);
>  #else
>  static inline __init void load_ucode_intel_bsp(void) {}
>  static inline __cpuinit void load_ucode_intel_ap(void) {}
>  static inline void show_ucode_info_early(void) {}
> +static inline int __init save_microcode_in_initrd_intel(void)
> +{
> +	return -EINVAL;
> +}

We leave those on one line as in the diff I sent you earlier.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
