Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaDAC0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:26:31 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:49631 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAC03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:26:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140401010901.GJ32556@tassilo.jf.intel.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
	<CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
	<20140331230347.GH32556@tassilo.jf.intel.com>
	<CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>
	<20140401010901.GJ32556@tassilo.jf.intel.com>
Date: Mon, 31 Mar 2014 19:26:28 -0700
X-Google-Sender-Auth: dl9AYFZaJTpDtrgQ8d1jt37UCZs
Message-ID: <CA+55aFw80CuJG6HYgHfsw-Tt8k5KpOOQSpOs0xyLQnZy5uxHrg@mail.gmail.com>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Anvin <hpa@zytor.com>, Jan Hubicka <hubicka@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 6:09 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> I think SYSCALL_DEFINE actually doesn't need it, as the syscall
> tables are visible in C. Only the syscall table itself
> needs to be visible.

Ahh, good point. The table used to be in asm for x86-32, but that got
fixed long ago so I guess that just isn't an issue any more.

>> and after that I strongly suspect that there will be only a handful of
>> cases left that are called from assembly language and that aren't
>> system calls. Things like "printk()" and friends that are really
>> special. They'd need a few manual "__visible" annotations.
>
> Ok. I think it's more than a handful though.

I guess an allmodconfig build with the LTO binutils should just
generate linker errors for all of them, so they should be easy to
find, though?

                Linus
