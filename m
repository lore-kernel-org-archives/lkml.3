Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaDASdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:33:46 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:51148 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDASdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:33:45 -0400
MIME-Version: 1.0
In-Reply-To: <1396373557-3387-3-git-send-email-andi@firstfloor.org>
References: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
	<1396373557-3387-3-git-send-email-andi@firstfloor.org>
Date: Tue, 1 Apr 2014 11:33:43 -0700
X-Google-Sender-Auth: VAwmkGxZjX6AlsNjsqLgC_yUZzg
Message-ID: <CA+55aFwA=vBbtWT=Zt-pi1caNf6L-m6nDHFnsJeX0wgTBnHhFg@mail.gmail.com>
Subject: Re: [PATCH 2/4] asmlinkage, x86: Add explicit __visible to arch/x86/*
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This still has these kinds of pointless changes. Why?

In the declaration of the function, the __visible is just noise. It's
not interesting to the caller, and doesn't add anything. In fact, I'd
argue that these kinds of declarations are not just noise, they are
*stupid* noise, because if the function is ever used by C code than
that "__visible" is pointless.

So get rid of the __visible. It's just more of the same confusion
where you think __visible and asmlinkage go together. They damn well
don't.

                  Linus

On Tue, Apr 1, 2014 at 10:32 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  #include <asm/sections.h>
>
>  /* Interrupt handlers registered during init_IRQ */
> -extern asmlinkage void apic_timer_interrupt(void);
> -extern asmlinkage void x86_platform_ipi(void);
> -extern asmlinkage void kvm_posted_intr_ipi(void);
> -extern asmlinkage void error_interrupt(void);
> -extern asmlinkage void irq_work_interrupt(void);
...
> +extern asmlinkage __visible void apic_timer_interrupt(void);
> +extern asmlinkage __visible void x86_platform_ipi(void);
> +extern asmlinkage __visible void kvm_posted_intr_ipi(void);
> +extern asmlinkage __visible void error_interrupt(void);
> +extern asmlinkage __visible void irq_work_interrupt(void);
