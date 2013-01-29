Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3A2CgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:36:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab3A2CgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:36:23 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9Wk9NYerj9wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=O1YP5waFyKMA:10 a=xYn_ilCtM3kMRqJS0koA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359426979.17639.10.camel@gandalf.local.home>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Date: Mon, 28 Jan 2013 21:36:19 -0500
In-Reply-To: <1359417749.17639.6.camel@gandalf.local.home>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	 <1359417749.17639.6.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 19:02 -0500, Steven Rostedt wrote:

> I've ran these through some basic tests and I don't see any issues. But
> why did you drop the 'comment' patch that you had in v6?
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 

I'm sorry but I need to un-Ack. Due to a test machine setup error, I've
been testing the same config over and over and not other configs.

Everything works great up until I enabled the dynamic tick and force
context tracking.

User time seems to be pretty much the same, but the kernel time is
screwed:

For all my other tests (I finally tested other configs and without your
patches) I had my kernel time test report something like this:

[root@bxtest ~]# time /work/c/kernelspin  10

real	0m10.001s
user	0m1.114s
sys	0m8.886s


But after enabling the force context_tracking I get this:

[root@bxtest ~]# time /work/c/kernelspin  10

real	0m10.001s
user	0m3.769s
sys	0m6.203s


Consistently. All the other runs always had a 1.X 8.X ratio. This seems
to give 3.7x 6.2x ratio consistently. Maybe it's more accurate then the
others. Or something else is broken.

I'll look deeper into it.

-- Steve


