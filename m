Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbaFYM1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:27:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbaFYM1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:27:16 -0400
Message-ID: <53AAC015.1060507@redhat.com>
Date: Wed, 25 Jun 2014 14:27:01 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Gleb Natapov <gleb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: kvm: x86.c:  Cleaning up variable is set more
 than once
References: <1403699158-22807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1403699158-22807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/06/2014 14:25, Rickard Strandqvist ha scritto:
> A struct member variable is set to the same value more than once
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/x86/kvm/x86.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f32a025..0f48eb7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4730,7 +4730,6 @@ static void emulator_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
>  	if (desc->g)
>  		var.limit = (var.limit << 12) | 0xfff;
>  	var.type = desc->type;
> -	var.present = desc->p;
>  	var.dpl = desc->dpl;
>  	var.db = desc->d;
>  	var.s = desc->s;
>

Thanks, applying this patch.

Paolo
