Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaEANTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:19:20 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:48661 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEANTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:19:19 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 1 May 2014 09:22:48 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140501102602.GP11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405010921550.18142@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu> <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404301701260.15279@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1404302310530.6261@ionos.tec.linutronix.de> <20140501102602.GP11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Peter Zijlstra wrote:

> On Thu, May 01, 2014 at 12:51:33AM +0200, Thomas Gleixner wrote:
> > And that's the issue which puzzles us. Let's look at what we expect:
> > 
> > Now the trace shows a different story:
> > 
> >      perf_fuzzer-4387  [001]  1802.628659: sys_enter:            
> NR 298 (69bb58, 0, ffffffff, 12, 0, 0)
> 
> That's a per-cpu event (.pid = -1, .cpu = 12), they don't get inherited,
> so the only thing keeping it alive is the fd the child got. So
> exit_files() killing this thing makes perfect sense.

wait, are you sure?  Isn't that pid=0, cpu=-1, group_fd=12?

my machine only has 8 cpus...

Vince
