Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3IMMUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:20:21 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:54461 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3IMMUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:20:17 -0400
Date: Fri, 13 Sep 2013 14:20:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Knut Petersen <Knut_Petersen@t-online.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, gcoady.lk@gmail.com
Subject: Re: [BUG] kernel panic during shutdown in run_timer_softirq()
Message-ID: <20130913122012.GA4844@somewhere>
References: <5232E294.9090909@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5232E294.9090909@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 12:01:56PM +0200, Knut Petersen wrote:
> Hi everybody!
> 
> Since about July I observe occasional kernel panics  happening only during system shutdown on two systems.
> 
> Hardware: mobos: both AOpen i915GMm-hfs mobos, cpus: Pentium-M Dothan / Banias, mem: 2GB
> Although the stack traces differ, there is one thing in common: CS:EIP is in run_timer_softirq().
> 
> A first report was posted to lkml on 2013-07-10: http://www.gossamer-threads.com/lists/linux/kernel/1744892?#1744892
> jpg of the stack trace: http://www.gossamer-threads.com/lists/engine?do=post_attachment;postatt_id=57017;list=linux
> 
> There were several reports of kernel panics with run_timer_softirq() in the call_trace.
> 
> @Grant: You reported a kernel panic during shutdown for kernel 3.7.5, but the jpg is not accessible.
> Could you please verify if your report is related?
> 
> The problem is still present in yesterdays git master, see attached stacktrace.
> A shortened transcription of that stacktrace:
> 
> Bug: unable to handle kernel paging request at ...
> [...]
> Call Trace:
> __do_softirq+[...]
> irq_exit+[...]
> smp_apic_timer_interrupt+[...]
> apic_timer_interrupt+[...]
> ?default_idle+[...]
> ?clocksource_mark_unstable+[...]
> ?default_idle+[...]
> arch_cpu_idle+[...]
> cpu_startup_entry+[...]
> rest_init+[...]
> start_kernel+[...]
> i386_start_kernel+[...]
> [...]
> EIP: run_timer_softirq+[...]
> Kernel panic panic - not syncing: Fatal exception in interrupt
> 
> Any idea how to debug that problem? Insert some debugging code and constantly rebooting one of the
> machines would be an option, but I don´t have a clue what to insert ....

Adding Thomas, in case he has a clue.

Thanks.

