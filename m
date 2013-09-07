Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3IGLXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 07:23:00 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49856 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3IGLW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 07:22:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVS4jGFOuysknJ_4BcdWRrYU=7KVfO8o_gxf-pVg=5gKA@mail.gmail.com>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
	<1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
	<CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
	<20130906173047.GT3966@linux.vnet.ibm.com>
	<CAMuHMdVS4jGFOuysknJ_4BcdWRrYU=7KVfO8o_gxf-pVg=5gKA@mail.gmail.com>
Date: Sat, 7 Sep 2013 13:22:57 +0200
X-Google-Sender-Auth: Cu54EmvH4FNbxRkEqSfZssLuA4U
Message-ID: <CAMuHMdXsAfo=LMF8E84_Lyhs+w5c3VKCEe7ZW5Bs7fwFV+J==w@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 8/9] nohz_full: Add full-system-idle state machine
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        josh@joshtriplett.org, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        darren@dvhart.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 8:50 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, Sep 6, 2013 at 7:30 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>>> Furthermore, it seems only hexagon, metag, mips, and x86 set NR_CPUS to 1
>>> if !SMP. On other architectures, NR_CPUS is not defined and presumed to be 0.
>>
>> Would it make sense to require that NR_CPUS=1 for !SMP?
>
> Yes, this looks reasonable to me.

Perhaps we can invert the logic and define only NR_CPUS in arch-specific
code, and derive SMP from NR_CPUS != 1 in generic code?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
