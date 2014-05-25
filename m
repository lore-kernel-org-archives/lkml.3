Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaEYXGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 19:06:06 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:36802 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaEYXGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 19:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <CALeycy9yGFXcwusztKokfybGUcK+eyCfmSD34+1eG+b88d7J6w@mail.gmail.com>
References: <CALeycy9yGFXcwusztKokfybGUcK+eyCfmSD34+1eG+b88d7J6w@mail.gmail.com>
Date: Sun, 25 May 2014 18:06:02 -0500
Message-ID: <CALeycy8ebxK0_nKFSvLimGHunSMHMcC0sN88u-HHUpAaupGkJA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: drop set_rflags callback
From: Wei Huang <huangwei.virt@gmail.com>
To: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com, gleb@kernel.org, avi.kivity@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not needed anymore now that the CPL is computed directly
> by the task switch code.
Given the current form, looks OK to me.

Reviewed-by: Wei Huang <huangwei.virt@gmail.com>
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_emulate.h | 1 -
>  arch/x86/kvm/x86.c                 | 6 ------
>  2 files changed, 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_emulate.h
> b/arch/x86/include/asm/kvm_emulate.h
> index 24ec1216596e..a04fe4eb237d 100644
> --- a/arch/x86/include/asm/kvm_emulate.h
> +++ b/arch/x86/include/asm/kvm_emulate.h
> @@ -189,7 +189,6 @@ struct x86_emulate_ops {
>   void (*set_idt)(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt);
>   ulong (*get_cr)(struct x86_emulate_ctxt *ctxt, int cr);
>   int (*set_cr)(struct x86_emulate_ctxt *ctxt, int cr, ulong val);
> - void (*set_rflags)(struct x86_emulate_ctxt *ctxt, ulong val);
>   int (*cpl)(struct x86_emulate_ctxt *ctxt);
>   int (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong *dest);
>   int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb313fc896dd..57eac309c22e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4646,11 +4646,6 @@ static int emulator_set_cr(struct x86_emulate_ctxt
> *ctxt, int cr, ulong val)
>   return res;
>  }
>
> -static void emulator_set_rflags(struct x86_emulate_ctxt *ctxt, ulong val)
> -{
> - kvm_set_rflags(emul_to_vcpu(ctxt), val);
> -}
> -
>  static int emulator_get_cpl(struct x86_emulate_ctxt *ctxt)
>  {
>   return kvm_x86_ops->get_cpl(emul_to_vcpu(ctxt));
> @@ -4835,7 +4830,6 @@ static const struct x86_emulate_ops emulate_ops = {
>   .set_idt     = emulator_set_idt,
>   .get_cr              = emulator_get_cr,
>   .set_cr              = emulator_set_cr,
> - .set_rflags          = emulator_set_rflags,
>   .cpl                 = emulator_get_cpl,
>   .get_dr              = emulator_get_dr,
>   .set_dr              = emulator_set_dr,
> --
> 1.8.3.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
