Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3GNTlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:41:10 -0400
Received: from claw.goop.org ([74.207.240.146]:49596 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab3GNTlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:41:08 -0400
Message-ID: <51E2FED2.7010306@goop.org>
Date: Sun, 14 Jul 2013 12:41:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tim Northover <t.p.northover@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [LLVMdev] [PATCH] x86/asm: avoid mnemonics without type suffix
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com> <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com> <CAFHTzf+PTVBcMYy2NQBQDLQgsWjbUBc+FYp2Hokd-002hXrePA@mail.gmail.com> <CA+55aFwpfn9FjkYeVpA8aPiGy6o8Z-JgJUNFmKF3H7nGqmbi+w@mail.gmail.com> <CAFHTzf+O7sdeETp5nsnoQDFeg-zE4q6Kmq9rHPZEr5z2jm2zxg@mail.gmail.com>
In-Reply-To: <CAFHTzf+O7sdeETp5nsnoQDFeg-zE4q6Kmq9rHPZEr5z2jm2zxg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 12:30 PM, Tim Northover wrote:
>> And that is why I think you should just consider "bt $x,y" to be
>> trivially the same thing and not at all ambiguous. Because there is
>> ABSOLUTELY ZERO ambiguity when people write
>>
>>    bt $63, mem
>>
>> Zero. Nada. None. The semantics are *exactly* the same for btl and btq
>> in this case, so why would you want the user to specify one or the
>> other?
> I don't think you've actually tested that, have you? (x86-64)
>
> int main() {
>   long val = 0xffffffff;
>   char res;
>
>   asm("btl $63, %1\n\tsetc %0" : "=r"(res) : "m"(val));
>   printf("%d\n", res);
>
>   asm("btq $63, %1\n\tsetc %0" : "=r"(res) : "m"(val));
>   printf("%d\n", res);
> }

Blerk.  It doesn't undermine the original point - that gas can
unambiguously choose the right operation size for a constant bit offset
- but yes, the operation size is meaningful in the case of a immediate
bit offset. Its pretty nasty of Intel to hide that detail in Table 3-2,
far from the instructions which use it...

    J

>
> Tim.
>

