Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbaKSRy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:54:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224AbaKSRyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:54:54 -0500
Message-ID: <546CD95F.3090603@redhat.com>
Date: Wed, 19 Nov 2014 18:54:39 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, gleb@kernel.org
CC: glx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove Fix Mes in emulate.c from needing fault addresses
References: <1416401298-2393-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1416401298-2393-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/11/2014 13:48, Nicholas Krause wrote:
> Removes fix me comments for needing fault addresses to be returned in certain
> functions if they fail as they are stored and included in this file via the \
> header file,paging_tmpl.h.


    KVM: x86: Remove FIXMEs in emulate.c
    
    Remove fixme comments about needing fault addresses to be returned.  These
    are propaagated from walk_addr_generic to gva_to_gpa and from there to
    ops->read_std and ops->write_std.

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/x86/kvm/emulate.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 9f8a2fa..f7f21d2 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2599,7 +2599,6 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
>  	ret = ops->read_std(ctxt, old_tss_base, &tss_seg, sizeof tss_seg,
>  			    &ctxt->exception);
>  	if (ret != X86EMUL_CONTINUE)
> -		/* FIXME: need to provide precise fault address */
>  		return ret;
>  
>  	save_state_to_tss16(ctxt, &tss_seg);
> @@ -2607,13 +2606,11 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
>  	ret = ops->write_std(ctxt, old_tss_base, &tss_seg, sizeof tss_seg,
>  			     &ctxt->exception);
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
> @@ -2624,7 +2621,6 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
>  				     sizeof tss_seg.prev_task_link,
>  				     &ctxt->exception);
>  		if (ret != X86EMUL_CONTINUE)
> -			/* FIXME: need to provide precise fault address */
>  			return ret;
>  	}
>  
> 

Applied, thanks.

Paolo
