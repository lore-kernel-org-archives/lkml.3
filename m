Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862Ab3DDQNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:13:09 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52279
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762605Ab3DDQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:13:07 -0400
Message-ID: <1365091982.2609.97.camel@laptop>
Subject: Re: [RFC] Add implicit barriers to irqsave/restore class of
 functions
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Date: Thu, 04 Apr 2013 18:13:02 +0200
In-Reply-To: <1364994622-14110-1-git-send-email-christian.ruppert@abilis.com>
References: <20130403130340.GA13826@ab42.lan>
	 <1364994622-14110-1-git-send-email-christian.ruppert@abilis.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 15:10 +0200, Christian Ruppert wrote:
> This patch adds implicit memory barriers to irqsave/restore functions
> of
> the ARC architecture port in line with what is done in other
> architectures.

> diff --git a/arch/arc/include/asm/irqflags.h
> b/arch/arc/include/asm/irqflags.h
> index ccd8480..c8147d1 100644
> --- a/arch/arc/include/asm/irqflags.h
> +++ b/arch/arc/include/asm/irqflags.h
> @@ -39,7 +39,7 @@ static inline long arch_local_irq_save(void)
>         "       flag.nz %0              \n"
>         : "=r"(temp), "=r"(flags)
>         : "n"((STATUS_E1_MASK | STATUS_E2_MASK))
> -       : "cc");
> +       : "memory", "cc");

That's not a memory barrier, that a memory clobber, aka a compiler
barrier.

