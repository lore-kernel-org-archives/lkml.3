Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3IFSuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:50:46 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51834 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3IFSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:50:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130906173047.GT3966@linux.vnet.ibm.com>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
	<1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
	<CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
	<20130906173047.GT3966@linux.vnet.ibm.com>
Date: Fri, 6 Sep 2013 20:50:41 +0200
X-Google-Sender-Auth: 0CY-eeHdw9xs2TdtWh5y8gicPCs
Message-ID: <CAMuHMdVS4jGFOuysknJ_4BcdWRrYU=7KVfO8o_gxf-pVg=5gKA@mail.gmail.com>
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
        sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 7:30 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>> Furthermore, it seems only hexagon, metag, mips, and x86 set NR_CPUS to 1
>> if !SMP. On other architectures, NR_CPUS is not defined and presumed to be 0.
>
> Would it make sense to require that NR_CPUS=1 for !SMP?

Yes, this looks reasonable to me.

> I tried creating a NR_CPUS_REALLY as follows:
>
> config NR_CPUS_REALLY
>         int "Fixed version of NR_CPUS"
>         default NR_CPUS if NR_CPUS
>         default 1 if !NR_CPUS
>
> But this still gave a warning on the first "default" even though it
> was not in effect.  I also tried using Kconfig "if":

IIRC, it tries to use the first default first, so the below may work
(the "if SMP" is probably not needed):

config NR_CPUS_REALLY
        int "Fixed version of NR_CPUS"
        default 1 if !SMP
        default NR_CPUS if SMP

> Defining NR_CPUS=1 if !SMP is looking pretty good to me just now.
> This would probably have other benefits -- I cannot be the only
> person who ever wanted this.  ;-)

Sure. I just didn't want to create patches for all architectures without
having a discussion first.

And it would be nice if it cuould be done in a central place, without
touching all architectures.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
