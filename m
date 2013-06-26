Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3FZQ45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:56:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49901 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab3FZQ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:56:56 -0400
Date: Wed, 26 Jun 2013 18:56:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wang YanQing <udknight@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        bp@suse.de, fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix override new_cpu_data.x86 with 486
Message-ID: <20130626165652.GA20280@pd.tnic>
References: <20130626162640.GA19913@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130626162640.GA19913@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:26:40AM +0800, Wang YanQing wrote:
> 
> We should set X86 to 486 before use cpuid
> to detect the cpu type, if we set X86 to 486
> after cpuid, then we will get 486 for ever.

Yep, that should be fixed, AFAICT. But it is too late for me in the day
to actually stare at asm and not miss anything so I'd need a doublecheck
from hpa.

> Yes, we will correct this in early_cpu_init,
> but it is still a wrong behavior, right? So
> just fix it.
> 
> I also find maybe we can delete the new_cpu_data,
> because we will over write all the information
> in early_cpu_init, and before early_cpu_init,
> there is no user of new_cpu_data, but this is
> another patch in the future.

That won't be that simple because reportedly there are cpus which report
different CPUID levels due to wrong MSR programming.

And, even if you went and removed it, you'd need to test your patch on
everything so that you can make sure you don't break anything. Which is
not worth the trouble, IMHO.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
