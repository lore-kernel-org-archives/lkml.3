Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3B1PjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:39:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47091 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3B1Piz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:38:55 -0500
Date: Thu, 28 Feb 2013 16:38:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, jwboyer@redhat.com
Subject: Re: Is: x86: mm: Fix vmalloc_fault oops during lazy MMU updates Was:
 Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
Message-ID: <20130228153846.GA9782@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
	tglx@linutronix.de, xen-devel@lists.xen.org,
	linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
	kraman@redhat.com, jwboyer@redhat.com
References: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default>
 <512E8B41.8000504@zytor.com>
 <20130227230009.GA32465@kroah.com>
 <512E91B7.6060102@zytor.com>
 <20130228142910.GA32354@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130228142910.GA32354@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 09:29:10AM -0500, Konrad Rzeszutek Wilk wrote:
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index fb674fd..4f7d793 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -378,10 +378,12 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
>  	if (pgd_none(*pgd_ref))
>  		return -1;
>  
> -	if (pgd_none(*pgd))
> +	if (pgd_none(*pgd)) {
>  		set_pgd(pgd, *pgd_ref);
> -	else
> +		arch_flush_lazy_mmu_mode();

Do I understand it correctly that this would cost us a
"preempt_disable(); preempt_enable()" needlessly on baremetal when
running with CONFIG_PARAVIRT enabled?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
