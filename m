Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaI1IJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 04:09:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50607 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaI1IJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 04:09:36 -0400
Message-ID: <1411891766.2029.131.camel@cyc>
Subject: Re: [PATCH] x86, MCE, AMD: use macros to compute bank MSRs
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, "Luck, Tony" <tony.luck@intel.com>
Date: Sun, 28 Sep 2014 16:09:26 +0800
In-Reply-To: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 10:16 +0800, Chen Yucong wrote:
> Avoid open coded calculations for bank MSRs by hiding the index
> of higher bank MSRs in well-defined macros.
> 
> No semantic changes.
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index 5d4999f..f8c56bd 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -217,7 +217,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
>  	for (bank = 0; bank < mca_cfg.banks; ++bank) {
>  		for (block = 0; block < NR_BLOCKS; ++block) {
>  			if (block == 0)
> -				address = MSR_IA32_MC0_MISC + bank * 4;
> +				address = MSR_IA32_MCx_MISC(bank);
>  			else if (block == 1) {
>  				address = (low & MASK_BLKPTR_LO) >> 21;
>  				if (!address)
> @@ -281,7 +281,7 @@ static void amd_threshold_interrupt(void)
>  			continue;
>  		for (block = 0; block < NR_BLOCKS; ++block) {
>  			if (block == 0) {
> -				address = MSR_IA32_MC0_MISC + bank * 4;
> +				address = MSR_IA32_MCx_MISC(bank);
>  			} else if (block == 1) {
>  				address = (low & MASK_BLKPTR_LO) >> 21;
>  				if (!address)
> @@ -314,8 +314,7 @@ static void amd_threshold_interrupt(void)
>  
>  			if (high & MASK_OVERFLOW_HI) {
>  				rdmsrl(address, m.misc);
> -				rdmsrl(MSR_IA32_MC0_STATUS + bank * 4,
> -				       m.status);
> +				rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
>  				m.bank = K8_MCE_THRESHOLD_BASE
>  				       + bank * NR_BLOCKS
>  				       + block;
> @@ -617,8 +616,7 @@ static int threshold_create_bank(unsigned int cpu, unsigned int bank)
>  		}
>  	}
>  
> -	err = allocate_threshold_blocks(cpu, bank, 0,
> -					MSR_IA32_MC0_MISC + bank * 4);
> +	err = allocate_threshold_blocks(cpu, bank, 0, MSR_IA32_MCx_MISC(bank));
>  	if (!err)
>  		goto out;
>  
Hi Boris,

Can you review the above patch?

thx!
cyc

