Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3DWUA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:00:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7658 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3DWUA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:00:27 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=W3keemsfVFYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=JwN9V2MEACcA:10 a=-whhAZm7gCjGifiUwfcA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366747223.9609.163.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] nohz: Add basic tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 23 Apr 2013 16:00:23 -0400
In-Reply-To: <0000013e38188092-7e0b72ea-9ae0-417c-902a-5e8a88282073-000000@email.amazonses.com>
References: <1366664905-21884-1-git-send-email-fweisbec@gmail.com>
	 <1366664905-21884-3-git-send-email-fweisbec@gmail.com>
	 <0000013e38188092-7e0b72ea-9ae0-417c-902a-5e8a88282073-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 18:12 +0000, Christoph Lameter wrote:
> On Mon, 22 Apr 2013, Frederic Weisbecker wrote:
> 
> > It's not obvious to find out why the full dynticks subsystem
> > doesn't always stop the tick: whether this is due to kthreads,
> > posix timers, perf events, etc...
> >
> > These new tracepoints are here to help the user diagnose
> > the failures and test this feature.
> 
> Very good. This will help a lot.

You can also do:

cd /sys/kernel/debug/tracing
echo 1 > max_graph_depth
echo function_graph > current_tracer

And then run your code, and look to see what happens on the cpu in
question:

cat per_cpu/cpuX/trace

The "max_graph_depth" of one will make the function graph tracer just
trace the first function that enters the kernel. You'll be able to see
if the kernel did anything to your userspace application that wasn't
planned.

"max_graph_depth" was added in 3.9-rc1

-- Steve


