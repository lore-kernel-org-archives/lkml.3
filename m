Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3I3QHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:07:23 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:54020 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab3I3QHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:07:20 -0400
MIME-Version: 1.0
In-Reply-To: <1380552959-9396-1-git-send-email-fweisbec@gmail.com>
References: <1380552959-9396-1-git-send-email-fweisbec@gmail.com>
Date: Mon, 30 Sep 2013 09:07:19 -0700
X-Google-Sender-Auth: dVg8NgIENJxQOlQLtuPXp6SoW_o
Message-ID: <CA+55aFy5YJkchyfCjbCKLGQMo34wcba9AVr2JMNPXZa5vKNT3g@mail.gmail.com>
Subject: Re: [GIT PULL] irq fix for 3.12-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "#3.9.." <stable@vger.kernel.org>, Paul Mackerras <paulus@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 7:55 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> ...
>     the chances for a stack overrun as reported in powerpc for example:
>
>     [ 1002.364577] do_IRQ: stack overflow: 1920
>     [ 1002.364653] CPU: 0 PID: 1602 Comm: qemu-system-ppc Not tainted 3.10.4-300.1.fc19.ppc64p7 #1
>     [ 1002.364734] Call Trace:
>     [ 1002.364770] [c0000000050a8740] [c0000000000157c0] .show_stack+0x130/0x200 (unreliable)
>     [ 1002.364872] [c0000000050a8810] [c00000000082f6d0] .dump_stack+0x28/0x3c
>     [ 1002.364955] [c0000000050a8880] [c000000000010b98] .do_IRQ+0x2b8/0x2c0
>     [ 1002.365039] [c0000000050a8930] [c0000000000026d4] hardware_interrupt_common+0x154/0x180
>     [ 1002.365148] --- Exception: 501 at .cp_start_xmit+0x3a4/0x820 [8139cp]
>     [ 1002.365148]     LR = .cp_start_xmit+0x390/0x820 [8139cp]
>     [ 1002.365359] [c0000000050a8d40] [c0000000006d7f14] .dev_hard_start_xmit+0x394/0x640
>  ...

Btw, I'd really wish people edited things like this when putting them
in the commit logs. I try to do it when I get them (usually though
Andrew's patch-bombs), just because there's just a ton of detail there
that just isn't relevant for the actual issue at hand.

The kernel oops messages try to contain all kinds of possibly-relevant
data, which makes them useful for a wide range of situations ("oh, it
looks like a single-bit flip"), but at the same time means that once
you know what the problem is, 90% of the data printed out is just pure
noise and at that point no longer helpful, but just makes it harder to
see what's actually the issue.

So please, after you've analyzed an oops, don't use the raw oops data
any more. Usually what remains relevant is the actual oops message
itself, and the backtrace.I try to generally edit out the hex
representation of the symbol information, and obviously stale entries
from the backtrace. I'm not consistent, see for example commit
6f6b8951897e (register info remains) vs commit d6394b590029 (mainly
just call trace) vs commit 3e6b11df2451 (where I just truncated it
mercilessly). And no, I don't always clean things up (it can be a
bother), but I generally try, so now I'm just trying to spread the
word..

Because at some point the excess verbiage really goes from "that's
useful" to being a blob of noise that actually takes away from the
message.

                    Linus
