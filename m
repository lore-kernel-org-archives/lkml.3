Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3GOSow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:44:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43658 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab3GOSov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:44:51 -0400
Message-ID: <51E44204.4000802@zytor.com>
Date: Mon, 15 Jul 2013 11:40:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tim Northover <t.p.northover@gmail.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LLVMdev <llvmdev@cs.uiuc.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [LLVMdev] [PATCH] x86/asm: avoid mnemonics without type suffix
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com> <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com> <CAFHTzf+PTVBcMYy2NQBQDLQgsWjbUBc+FYp2Hokd-002hXrePA@mail.gmail.com> <CA+55aFwpfn9FjkYeVpA8aPiGy6o8Z-JgJUNFmKF3H7nGqmbi+w@mail.gmail.com> <CAFHTzf+O7sdeETp5nsnoQDFeg-zE4q6Kmq9rHPZEr5z2jm2zxg@mail.gmail.com> <CA+55aFwcxWR-SFD=QFXAb38sPnN-hcOBF-W+NuRBSMx-n+RnxQ@mail.gmail.com>
In-Reply-To: <CA+55aFwcxWR-SFD=QFXAb38sPnN-hcOBF-W+NuRBSMx-n+RnxQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 12:49 PM, Linus Torvalds wrote:
> On Sun, Jul 14, 2013 at 12:30 PM, Tim Northover <t.p.northover@gmail.com> wrote:
>>
>> I don't think you've actually tested that, have you? (x86-64)
> 
> Oh, you're right, for constants > 5 bits you have that other thing
> going on. I didn't think about the fact that the constant changed in
> the middle of the thread (it started out as 1).
> 
> We use the gcc constraint "I" (0-31) in the kernel for this reason.
> 
>              Linus

This is also why the Intel manuals point out that "some assemblers" can
take things like:

	bt[l] $63,(%rsi)

... and turn it into:

	btl $31,4(%rsi)

This is definitely the friendly thing to do toward the human programmer.
 Unfortunately gas doesn't, nor does e.g. NASM.

	-hpa


