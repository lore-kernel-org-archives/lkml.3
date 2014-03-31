Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaCaQcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:32:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:34531 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaCaQcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:32:31 -0400
Date: Mon, 31 Mar 2014 18:32:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf_fuzzer: BUG in kfree() in ftrace_graph_exit_task
In-Reply-To: <alpine.DEB.2.10.1403311207490.8953@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403311826280.14882@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403311207490.8953@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014, Vince Weaver wrote:
> 
> This turned up with the perf_fuzzer, haswell, 3.14.
> 
> I'm not sure if this is related to the other object corruption bug I am 
> seeing.  The sympstoms are similar (BUG when dereferencing low invalid
> kernel address) but this time the hrtimer code is not involved at all.
> 
> This isn't reproducible, that is if I re-run the fuzzer with the same 
> random seed after reboot the bug doesn't trigger.
> 
> 
> [ 5498.573458] BUG: unable to handle kernel NULL pointer dereference at 000000000000006c
> [ 5498.585181] IP: [<ffffffff81189111>] kfree+0x91/0x220
> [ 5498.593887] PGD 0 
> [ 5498.599365] Oops: 0000 [#1] SMP 
> [ 5498.606127] Dumping ftrace buffer:
> [ 5498.612973]    (ftrace buffer empty)
> [ 5498.619868] Modules linked in: nfsd auth_rpcgss  .....
> [ 5498.720303] CPU: 1 PID: 13 Comm: ksoftirqd/1 Tainted: G        W    3.14.0+ #14

It's already tainted with W, so there was a warning before that
crash. It would be interesting to see that as well.

Thanks,

	tglx


