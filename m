Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaEESny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:43:54 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:34475 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaEESnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:43:52 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 5 May 2014 14:47:32 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140505171428.GU26782@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405051443260.31072@vincent-weaver-1.umelst.maine.edu>
References: <20140502172731.GK30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu> <20140505093124.GN17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405051309160.31072@vincent-weaver-1.umelst.maine.edu> <20140505171428.GU26782@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Peter Zijlstra wrote:

> Cute.. does the below cure?
> 
> 
> ---
> Subject: perf: Fix perf_event_init_context()
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon May  5 19:12:20 CEST 2014
> 
> perf_pin_task_context() can return NULL but perf_event_init_context()
> assumes it will not, correct this.

It makes the oops go away, but it does make the fuzzer become unkillable 
while using 100% CPU.

It looks like it is stuck repeating this forever:
	perf_fuzzer-5256  [000]   275.943049: kmalloc:              (T.1262+0xe) call_site=ffffffff810d022f ptr=0xffff8800cb028400 bytes_req=216 bytes_alloc=256 gfp_flags=GFP_KERNEL|GFP_ZERO
	perf_fuzzer-5256  [000]   275.943057: function:             perf_lock_task_context
	perf_fuzzer-5256  [000]   275.943057: function:             alloc_perf_context
and memory is slowly leaking away.


Meanwhile the haswell and AMD machines have been fuzzing away without 
issue, I don't know why the core2 machine is always the trouble maker.

Vince

