Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab3BGCuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 21:50:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15347 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab3BGCuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 21:50:19 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M5gr15I6uLgA:10 a=wVWRYvi7pVcVGI_hNREA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360205415.2621.60.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 06 Feb 2013 21:50:15 -0500
In-Reply-To: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll reply to this as I come up with comments.

First thing is, don't call it NO_HZ_FULL. A better name would be
NO_HZ_CPU. I would like to reserve NO_HZ_FULL when we totally remove
jiffies :-)

And the kconfig help should probably call it "Adaptive tickless" or
"Tickless for single tasks". The full tickless system really sounds like
we totally removed jiffies. It should explain it better. Something like:

  "Adaptive tickless system"

With this option, you may designate CPUs that will turn off the periodic
interrupt "tick" when only a single task is scheduled on the CPU. This
is similar to NO_HZ where the tick is suspended when the CPU goes into
idle. With this option, it takes it one step further. When only a single
task is scheduled on the CPU, there scheduler does not need to keep
track of time slices, as the running task does not need to be preempted
for other tasks. Stopping the tick allows the task to avoid being
interrupted by service routines by the kernel.

CPUs must be designated at time of boot via the kernel command line
parameter (cpu_nohz) and must be a subset of the rcu_nocb parameter,
which prevents RCU service routines from being called on the CPUs as
well.

---

Something like that.

-- Steve


