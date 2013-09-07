Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024Ab3IGJN6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 05:13:58 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49531 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3IGJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 05:13:54 -0400
Date: Sat, 7 Sep 2013 11:13:48 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        josh@joshtriplett.org, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        darren@dvhart.com,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 8/9] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130907091348.GA3487@free.fr>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
 <20130906173047.GT3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130906173047.GT3966@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul, All,

On 2013-09-06 10:30 -0700, Paul E. McKenney spake thusly:
[--SNIP--]
> I also tried using Kconfig "if":
> 
> if SMP
> config NR_CPUS_REALLY
> 	int "Fixed version of NR_CPUS"
> 	default NR_CPUS
> endif
> if !SMP
> config NR_CPUS_REALLY
> 	int "Fixed version of NR_CPUS"
> 	default 1 if !SMP

The 'if !SMP' here is unneeded, you're already in a 'if !SMP' if-block.

> endif
> 
> However, Kconfig complained about the use of NR_CPUS even though this
> was under an "if" whose condition was not set.  Perhaps someone with
> better Kconfig-fu than I have can come up with something.

That's because the 'if' condition is added to the dependency list of the
symbol(s) that is(are) enclosed in the if.

'if' in Kconfig behaves the same way as an 'if' in C. What you expected
(I believe) was the behaviour of '#ifdef', which is not the case. From
Documentation/kbuild/kconfig-language.txt:

    ---8<---
    if:

            "if" <expr>
            <if block>
            "endif"

    This defines an if block. The dependency expression <expr> is appended
    to all enclosed menu entries.
    ---8<---

There's no equivlaent to '#ifdef' in Kconfig.

I'll see if I can come up with a meaningfull construct that fixes your
use-case. Don't hold your breath, though! ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
