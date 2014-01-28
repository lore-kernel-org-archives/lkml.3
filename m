Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaA1ApI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:45:08 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56828 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaA1ApG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:45:06 -0500
MIME-Version: 1.0
In-Reply-To: <52E6F84F.1000408@zytor.com>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <20140127002255.GA10323@ZenIV.linux.org.uk> <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
 <20140127074208.GB10323@ZenIV.linux.org.uk> <52E6D866.604@amacapital.net>
 <CA+55aFzWRjNC4kPeVad3isOOW+vZhnzX0Gk5_8QzD16GZEw5Kg@mail.gmail.com>
 <20140127223257.GE10323@ZenIV.linux.org.uk> <CA+55aFyajjkCtRiTOS2AbFOWi7qt2FUnW6T3iG9nXqoZ0O9Ljg@mail.gmail.com>
 <CALCETrUXjFYd7ZC958WoNk1mnPCw2kw5jt-Ywo309EObnuqFAg@mail.gmail.com> <52E6F84F.1000408@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 27 Jan 2014 16:44:45 -0800
Message-ID: <CALCETrVGwrw=1ktqSYFys4hSZ_X0xpBfYLZQbKudNWvt0hdhJA@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 4:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/27/2014 02:46 PM, Andy Lutomirski wrote:
>>
>> I think that sysret for sigreturn is probably not very interesting.
>> On the other hand, sysret for #PF might be a huge win, despite being
>> even scarier.
>>
>
> SYSRET for #PF or other exceptions is a nonstarter; register state is
> live at that point.

I mean sysret-via-trampoline for #PF.

It's scary, it probably has issues with ptrace and interrupts that hit
while the trampoline is still running, and it could break anything
that writes past the red zone, but I think it could work.

No, I don't particularly want to implement (and debug) such a beast.

(I will continue cursing Intel -- why can't we have a fast way to
return to 64-bit userspace with complete control of all non-segment
registers?  sysret is *almost* the right thing.)

--Andy

>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
