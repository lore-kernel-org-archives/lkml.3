Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab3FCIVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab3FCIVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:21:10 -0400
Date: Mon, 3 Jun 2013 11:21:08 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: Emulate multibyte NOP
Message-ID: <20130603082108.GB4725@redhat.com>
References: <1369912959-18715-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369912959-18715-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 01:22:39PM +0200, Paolo Bonzini wrote:
> This is encountered when booting RHEL5.9 64-bit.  There is another bug
> after this one that is not a simple emulation failure, but this one lets
> the boot proceed a bit.
> 
> Cc: <stable@vger.kernel.org> # 3.9
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Applied to master, thanks.

> ---
>  arch/x86/kvm/emulate.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 48e6abd..aa68106 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3987,7 +3987,8 @@ static const struct opcode twobyte_table[256] = {
>  	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
>  	N, D(ImplicitOps | ModRM), N, N,
>  	/* 0x10 - 0x1F */
> -	N, N, N, N, N, N, N, N, D(ImplicitOps | ModRM), N, N, N, N, N, N, N,
> +	N, N, N, N, N, N, N, N,
> +	D(ImplicitOps | ModRM), N, N, N, N, N, N, D(ImplicitOps | ModRM),
>  	/* 0x20 - 0x2F */
>  	DIP(ModRM | DstMem | Priv | Op3264, cr_read, check_cr_read),
>  	DIP(ModRM | DstMem | Priv | Op3264, dr_read, check_dr_read),
> @@ -4822,6 +4823,7 @@ twobyte_insn:
>  	case 0x08:		/* invd */
>  	case 0x0d:		/* GrpP (prefetch) */
>  	case 0x18:		/* Grp16 (prefetch/nop) */
> +	case 0x1f:		/* nop */
>  		break;
>  	case 0x20: /* mov cr, reg */
>  		ctxt->dst.val = ops->get_cr(ctxt, ctxt->modrm_reg);
> -- 
> 1.8.1.4

--
			Gleb.
