Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3GOS67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:58:59 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:53710 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3GOS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:58:57 -0400
MIME-Version: 1.0
In-Reply-To: <51E443AD.3020907@zytor.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
	<51E2FAB9.9050900@goop.org>
	<51E443AD.3020907@zytor.com>
Date: Mon, 15 Jul 2013 11:58:56 -0700
X-Google-Sender-Auth: 5FrVeus9D0N1LkoG3qIx-E0Z33Q
Message-ID: <CA+55aFyssHTdvQ4Gsj9bJB_4X4Ca_JSxmNY0Qv1j=75ixJEajA@mail.gmail.com>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> To be fair, we *ought to* be able to do something like:
>
>         asm volatile(LOCK_PREFIX "bts%z0 %1,%0"
>                         : BITOP_ADDR(addr) : "Ir" (nr) : "memory");
>
> ... but some older version of gcc are broken and emit "ll" rather than
> "q".  Furthermore, since that would actually result in *worse* code
> emitted overall (unnecessary REX prefixes), I'm not exactly happy on the
> idea.

I really think the "worse code" argument is the one that matters.

Specifying the size of the operation is *overspecifying* things,
exactly because the 32-bit encoding is actually the *better* one when
possible.

So it's much better to underspecify and let the assembler pick the
best encoding, than it is to use an explicit size and get worse code.

Which is why I brought up the issue of small constants and short
jumps. I really believe this is exactly the same issue.

              Linus
