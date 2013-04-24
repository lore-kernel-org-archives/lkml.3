Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab3DXUZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:25:22 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63536 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab3DXUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:25:21 -0400
Date: Wed, 24 Apr 2013 13:25:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] nohz: Fix unavailable tick_stop tracepoint in dynticks
 idle
In-Reply-To: <1366814698-8260-2-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.02.1304241323500.7574@chino.kir.corp.google.com>
References: <1366814698-8260-1-git-send-email-fweisbec@gmail.com> <1366814698-8260-2-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013, Frederic Weisbecker wrote:

> The trace_tick_stop() tracepoint is only available in full
> dynticks. But it's also used by dynticks-idle so let's build
> it for the latter config as well.
> 
> This fixes:
> 
>      kernel/time/tick-sched.c: In function tick_nohz_stop_sched_tick:
>      kernel/time/tick-sched.c:644: error: implicit declaration of function trace_tick_stop
>      make[2]: *** [kernel/time/tick-sched.o] Erreur 1
> 
> Reported-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David Rientjes <rientjes@google.com>

Fixes all of the build errors I've detected in timers/nohz.
