Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3GNTtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:49:46 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:57156 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3GNTtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAFHTzf+O7sdeETp5nsnoQDFeg-zE4q6Kmq9rHPZEr5z2jm2zxg@mail.gmail.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
	<CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
	<CAFHTzf+PTVBcMYy2NQBQDLQgsWjbUBc+FYp2Hokd-002hXrePA@mail.gmail.com>
	<CA+55aFwpfn9FjkYeVpA8aPiGy6o8Z-JgJUNFmKF3H7nGqmbi+w@mail.gmail.com>
	<CAFHTzf+O7sdeETp5nsnoQDFeg-zE4q6Kmq9rHPZEr5z2jm2zxg@mail.gmail.com>
Date: Sun, 14 Jul 2013 12:49:44 -0700
X-Google-Sender-Auth: ozXj3iaKh1SINzRqxIy8lcp4X88
Message-ID: <CA+55aFwcxWR-SFD=QFXAb38sPnN-hcOBF-W+NuRBSMx-n+RnxQ@mail.gmail.com>
Subject: Re: [LLVMdev] [PATCH] x86/asm: avoid mnemonics without type suffix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tim Northover <t.p.northover@gmail.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LLVMdev <llvmdev@cs.uiuc.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 12:30 PM, Tim Northover <t.p.northover@gmail.com> wrote:
>
> I don't think you've actually tested that, have you? (x86-64)

Oh, you're right, for constants > 5 bits you have that other thing
going on. I didn't think about the fact that the constant changed in
the middle of the thread (it started out as 1).

We use the gcc constraint "I" (0-31) in the kernel for this reason.

             Linus
