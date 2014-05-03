Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaECEcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 00:32:55 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:57273 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaECEcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 00:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>
References: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>
Date: Fri, 2 May 2014 21:32:53 -0700
X-Google-Sender-Auth: bw3EgB8wuY598PLHFhFMIZf9-30
Message-ID: <CA+55aFwmhOGRv0Z7Sqgk08pTOYDJg4C9GB_XNHRAtiCLFrHG1g@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Return to kernel without IRET
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 4:53 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On my box, this saves about 100ns on each interrupt and trap that
> happens while running in kernel space.  This speeds up my kernel_pf
> microbenchmark by about 17%.

Btw, would you mind _trying_ to do a similar trick for the "return to
user space" case?

At least as a proof-of-concept, having a code sequence in user mode
trampoline that does

   popq %rsi
   popq %r11
   retq $128

and building up a stack in user space at '%rsp-128' that has the
values or rsi/r11/rip should allow us to use 'sysret'. Hmm?

            Linus
