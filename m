Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbaGXLBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:01:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59029 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757743AbaGXLBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:01:10 -0400
Date: Thu, 24 Jul 2014 13:01:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 4/8] x86, microcode, intel: fix missing declaration
Message-ID: <20140724110106.GJ19239@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-5-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406146251-8540-5-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:10:47PM -0300, Henrique de Moraes Holschuh wrote:
> Rename apply_microcode() in microcode/intel.c to apply_microcode_intel(),
> and declare it as extern in the asm/microcode_intel.h header.
> 
> This is a cosmetic fix to silence a warning issued by sparse.  It brings
> the microcode/intel.c driver in line with what microcode/amd.c is doing.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> ---
>  arch/x86/include/asm/microcode_intel.h |    1 +
>  arch/x86/kernel/cpu/microcode/intel.c  |    4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
> index 9067166..2bdbc6b 100644
> --- a/arch/x86/include/asm/microcode_intel.h
> +++ b/arch/x86/include/asm/microcode_intel.h
> @@ -62,6 +62,7 @@ extern int microcode_sanity_check(void *mc, int print_err);
>  extern int get_matching_sig(unsigned int csig, int cpf, void *mc, int rev);
>  extern int
>  update_match_revision(struct microcode_header_intel *mc_header, int rev);
> +extern int apply_microcode_intel(int cpu);
>  
>  #ifdef CONFIG_MICROCODE_INTEL_EARLY
>  extern void __init load_ucode_intel_bsp(void);
> diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
> index a276fa7..a51cb19 100644
> --- a/arch/x86/kernel/cpu/microcode/intel.c
> +++ b/arch/x86/kernel/cpu/microcode/intel.c
> @@ -127,7 +127,7 @@ static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
>  	return get_matching_microcode(csig, cpf, mc_intel, crev);
>  }
>  
> -int apply_microcode(int cpu)
> +int apply_microcode_intel(int cpu)

Actually, this function should be static. The AMD counterpart is used in
amd_early.c too, that's why it is exported there, unlike here.

The "_intel" suffix is ok.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
