Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbbA0WMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:12:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37585 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759543AbbA0WMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:12:50 -0500
Date: Tue, 27 Jan 2015 23:12:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: James Dingwall <james@dingwall.me.uk>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.18.2 / xen 4.4.1 dom0 - microcode oops
Message-ID: <20150127221231.GE3351@pd.tnic>
References: <20150122055242.GA11089@dingwall.me.uk>
 <20150122082003.GA3441@pd.tnic>
 <54C10DB6.2050708@oracle.com>
 <54C10ED0.1010302@oracle.com>
 <20150122153002.GA3554@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150122153002.GA3554@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Boris,

On Thu, Jan 22, 2015 at 04:30:02PM +0100, Borislav Petkov wrote:
> On Thu, Jan 22, 2015 at 09:53:04AM -0500, Boris Ostrovsky wrote:
> > Alternatively, we could return an error (-EINVAL?) from
> > microcode_init() when either of these two conditions is true.
> 
> Yeah, this should be the right fix.
> 
> James, does that fix your issue? (It should.)
> 
> ---
> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
> index 15c29096136b..36a83617eb21 100644
> --- a/arch/x86/kernel/cpu/microcode/core.c
> +++ b/arch/x86/kernel/cpu/microcode/core.c
> @@ -552,7 +552,7 @@ static int __init microcode_init(void)
>  	int error;
>  
>  	if (paravirt_enabled() || dis_ucode_ldr)
> -		return 0;
> +		return -EINVAL;
>  
>  	if (c->x86_vendor == X86_VENDOR_INTEL)
>  		microcode_ops = init_intel_microcode();

would you do the honor and write a proper patch? You found the bug so...
:-D

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
