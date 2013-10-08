Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3JHI0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:26:31 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38733 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3JHI02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:26:28 -0400
Date: Tue, 8 Oct 2013 10:26:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008082624.GC7232@gmail.com>
References: <20131006082340.GA24568@localhost>
 <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
 <20131007021118.GA27927@localhost>
 <20131007051038.GA9764@localhost>
 <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost>
 <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <20131008075816.GA6346@gmail.com>
 <20131008082057.GA19657@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008082057.GA19657@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fengguang Wu <fengguang.wu@intel.com> wrote:

> After enabling CONFIG_DEBUG_OBJECTS_TIMERS=y, it will issue a WARNING followed by a "BUG: ..."

Cool!

> [    2.802167] parport_pc 00:04: reported by Plug and Play ACPI
> [    2.803818] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
> [    2.806035] kobject: 'parport_pc.956' (ffff880006dc3820): kobject_release, parent           (null) (delayed)
> [    2.808626] ------------[ cut here ]------------                                                            
> [    2.809776] WARNING: CPU: 1 PID: 1 at /c/wfg/linux/lib/debugobjects.c:260 debug_print_object+0x7c/0x8d()
> [    2.812433] ODEBUG: init active (active state 0) object type: timer_list hint:           (null)         
> ......
> [    3.796079] BUG: unable to handle kernel NULL pointer dereference at           (null)

Mind posting the full backtrace? It should show the actual callsite that 
zaps the timer. I don't think we got that dump so far, I've only seen 
timer list corruption backtraces. (but I haven't read the whole thread.)

Thanks,

	Ingo
