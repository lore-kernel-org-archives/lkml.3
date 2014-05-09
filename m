Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaEIHy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:54:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40541 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaEIHy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:54:56 -0400
Date: Fri, 9 May 2014 09:54:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andres Freund <andres@anarazel.de>
Cc: Borislav Petkov <bp@suse.de>, x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: Fix typo preventing msr_set/clear_bit from
 having an effect
Message-ID: <20140509075452.GA16058@pd.tnic>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
 <1399598957-7011-2-git-send-email-andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399598957-7011-2-git-send-email-andres@anarazel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 03:29:16AM +0200, Andres Freund wrote:
> Due to a typo the msr accessor function introduced in
> 22085a66c2fab6cf9b9393c056a3600a6b4735de didn't have any lasting
> effects because they accidentally wrote the old value back.
> 
> After c0a639ad0bc6b178b46996bd1f821a04643e2bde this at the very least
> this causes cpuid limits not to be lifted on some cpus leading to
> missing capabilities for those.
> 
> Signed-off-by: Andres Freund <andres@anarazel.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/lib/msr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
> index db9db44..4362373 100644
> --- a/arch/x86/lib/msr.c
> +++ b/arch/x86/lib/msr.c
> @@ -76,7 +76,7 @@ static inline int __flip_bit(u32 msr, u8 bit, bool set)
>  	if (m1.q == m.q)
>  		return 0;
>  
> -	err = msr_write(msr, &m);
> +	err = msr_write(msr, &m1);
>  	if (err)
>  		return err;

Good catch, thanks, and sorry about the screwup! :-[

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
