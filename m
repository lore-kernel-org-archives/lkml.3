Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaBAK7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 05:59:12 -0500
Received: from ozlabs.org ([203.10.76.45]:42911 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbaBAK7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 05:59:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Long <dave.long@linaro.org>, linux-arm-kernel@lists.infradead.org
Cc: James Hogan <james.hogan@imgtec.com>, Andi Kleen <ak@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Detect section mismatches in thumb relocations
In-Reply-To: <1391193193-28572-1-git-send-email-dave.long@linaro.org>
References: <1391193193-28572-1-git-send-email-dave.long@linaro.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Sat, 01 Feb 2014 21:23:16 +1030
Message-ID: <8738k35ckj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Long <dave.long@linaro.org> writes:
> From: "David A. Long" <dave.long@linaro.org>
>
> Add processing for normally encountered thumb relocation types so that
> section mismatches will be detected.
>
> Signed-off-by: David A. Long <dave.long@linaro.org>

Happiest for this to go through an ARM tree, so:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

> ---
>  scripts/mod/modpost.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 1785576..9e6c996 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1498,6 +1498,16 @@ static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
>  #define R_ARM_JUMP24	29
>  #endif
>  
> +#ifndef	R_ARM_THM_CALL
> +#define	R_ARM_THM_CALL		10
> +#endif
> +#ifndef	R_ARM_THM_JUMP24
> +#define	R_ARM_THM_JUMP24	30
> +#endif
> +#ifndef	R_ARM_THM_JUMP19
> +#define	R_ARM_THM_JUMP19	51
> +#endif
> +
>  static int addend_arm_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
>  {
>  	unsigned int r_typ = ELF_R_TYPE(r->r_info);
> @@ -1511,6 +1521,9 @@ static int addend_arm_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
>  	case R_ARM_PC24:
>  	case R_ARM_CALL:
>  	case R_ARM_JUMP24:
> +	case R_ARM_THM_CALL:
> +	case R_ARM_THM_JUMP24:
> +	case R_ARM_THM_JUMP19:
>  		/* From ARM ABI: ((S + A) | T) - P */
>  		r->r_addend = (int)(long)(elf->hdr +
>  		              sechdr->sh_offset +
> -- 
> 1.8.1.2
