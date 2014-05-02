Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaEBQTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:19:01 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:61521 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbaEBQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:18:59 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 2 May 2014 12:22:30 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140502154217.GW11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu>
References: <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu> <20140502154217.GW11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'll try the patch next.

Meanwhile, can polling on a closed event cause problems with the reference 
count?

In my various failure traces there's always been a poll() active at the 
time of crash, and I added some trace_printk()s and it looks like poll is 
at least attempting to poll on the closed file descriptor that's causing 
us problems.

Vince
