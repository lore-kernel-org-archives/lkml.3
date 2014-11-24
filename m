Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaKXKKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:10:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaKXKKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:10:52 -0500
Message-ID: <5473041E.3070802@redhat.com>
Date: Mon, 24 Nov 2014 11:10:38 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, gleb@kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Remove FIXMEs in emulate.c
References: <1416803131-3190-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1416803131-3190-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/11/2014 05:25, Nicholas Krause wrote:
> Remove fixme comments about needing fault addresses to be returned.  These
> are propaagated from walk_addr_generic to gva_to_gpa and from there to
> ops->read_std and ops->write_std.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/x86/kvm/emulate.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 9f8a2fa..16b5d52 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2751,7 +2751,6 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
>  	ret = ops->read_std(ctxt, old_tss_base, &tss_seg, sizeof tss_seg,
>  			    &ctxt->exception);
>  	if (ret != X86EMUL_CONTINUE)
> -		/* FIXME: need to provide precise fault address */
>  		return ret;
>  
>  	save_state_to_tss32(ctxt, &tss_seg);
> @@ -2760,13 +2759,11 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
>  	ret = ops->write_std(ctxt, old_tss_base + eip_offset, &tss_seg.eip,
>  			     ldt_sel_offset - eip_offset, &ctxt->exception);
>  	if (ret != X86EMUL_CONTINUE)
> -		/* FIXME: need to provide precise fault address */
>  		return ret;
>  
>  	ret = ops->read_std(ctxt, new_tss_base, &tss_seg, sizeof tss_seg,
>  			    &ctxt->exception);
>  	if (ret != X86EMUL_CONTINUE)
> -		/* FIXME: need to provide precise fault address */
>  		return ret;
>  
>  	if (old_tss_sel != 0xffff) {
> @@ -2777,7 +2774,6 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
>  				     sizeof tss_seg.prev_task_link,
>  				     &ctxt->exception);
>  		if (ret != X86EMUL_CONTINUE)
> -			/* FIXME: need to provide precise fault address */
>  			return ret;
>  	}
>  
> 

Thanks, this patch has been applied already.

Paolo
