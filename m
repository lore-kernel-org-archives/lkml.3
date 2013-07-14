Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3GNTaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:30:04 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43253 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3GNTaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:30:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwpfn9FjkYeVpA8aPiGy6o8Z-JgJUNFmKF3H7nGqmbi+w@mail.gmail.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
	<CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
	<CAFHTzf+PTVBcMYy2NQBQDLQgsWjbUBc+FYp2Hokd-002hXrePA@mail.gmail.com>
	<CA+55aFwpfn9FjkYeVpA8aPiGy6o8Z-JgJUNFmKF3H7nGqmbi+w@mail.gmail.com>
Date: Sun, 14 Jul 2013 19:30:00 +0000
Message-ID: <CAFHTzf+O7sdeETp5nsnoQDFeg-zE4q6Kmq9rHPZEr5z2jm2zxg@mail.gmail.com>
Subject: Re: [LLVMdev] [PATCH] x86/asm: avoid mnemonics without type suffix
From: Tim Northover <t.p.northover@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LLVMdev <llvmdev@cs.uiuc.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And that is why I think you should just consider "bt $x,y" to be
> trivially the same thing and not at all ambiguous. Because there is
> ABSOLUTELY ZERO ambiguity when people write
>
>    bt $63, mem
>
> Zero. Nada. None. The semantics are *exactly* the same for btl and btq
> in this case, so why would you want the user to specify one or the
> other?

I don't think you've actually tested that, have you? (x86-64)

int main() {
  long val = 0xffffffff;
  char res;

  asm("btl $63, %1\n\tsetc %0" : "=r"(res) : "m"(val));
  printf("%d\n", res);

  asm("btq $63, %1\n\tsetc %0" : "=r"(res) : "m"(val));
  printf("%d\n", res);
}

Tim.
