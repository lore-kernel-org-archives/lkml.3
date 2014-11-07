Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaKGUFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:05:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46818 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaKGUFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:05:06 -0500
Date: Fri, 7 Nov 2014 21:05:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 8/8] x86, microcode, intel: defend apply_microcode_intel
 with BUG_ON
Message-ID: <20141107200501.GF5180@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-9-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410197875-19252-9-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:37:54PM -0300, Henrique de Moraes Holschuh wrote:
> Microcode updates that requires an unknown loader should never reach the
> apply_* functions (the code should have rejected it earlier).  Likewise
> for an unknown microcode header layout.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> ---
>  arch/x86/kernel/cpu/microcode/intel.c       |    2 ++
>  arch/x86/kernel/cpu/microcode/intel_early.c |    2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
> index 40caef1..439681f 100644
> --- a/arch/x86/kernel/cpu/microcode/intel.c
> +++ b/arch/x86/kernel/cpu/microcode/intel.c
> @@ -157,6 +157,8 @@ static int apply_microcode_intel(int cpu)
>  	if (mc_intel == NULL)
>  		return 0;
>  
> +	BUG_ON(mc_intel->hdr.hdrver != 1 || mc_intel->hdr.ldrver != 1);
> +
>  	/* Intel SDM vol 3A section 9.11.6, page 9-34 */
>  	if (WARN_ONCE((unsigned long)(mc_intel->bits) % 16,
>  		"microcode data incorrectly aligned"))
> diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
> index 994c59b..095db11 100644
> --- a/arch/x86/kernel/cpu/microcode/intel_early.c
> +++ b/arch/x86/kernel/cpu/microcode/intel_early.c
> @@ -671,6 +671,8 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
>  	if (mc_intel == NULL)
>  		return 0;
>  
> +	BUG_ON(mc_intel->hdr.hdrver != 1 || mc_intel->hdr.ldrver != 1);
> +
>  	mcu_data = mc_intel->bits;
>  	aligned_mcu_data = mc_intel->bits;

Both not needed, because we're running all microcode through
microcode_sanity_check() first which already does that check.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
