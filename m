Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946713Ab3BHQSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:18:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18156 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946450Ab3BHQSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:18:12 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M5gr15I6uLgA:10 a=NufY4J3AAAAA:8 a=DOYHrJKly7pEN2T6RRIA:9 a=PUjeQqilurYA:10 a=re9sYKne76oA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360340288.2621.112.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 08 Feb 2013 11:18:08 -0500
In-Reply-To: <CAFTL4hyfnhjezjL2QfVKYDB-bwh4BSGyX8xmhpdmxTf+EAu+yA@mail.gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	 <1360205415.2621.60.camel@gandalf.local.home>
	 <CAFTL4hzJ9FLNTqiBdB0SCWvxgN=p=M54e1PNWe6cp+C9A=DXxA@mail.gmail.com>
	 <1360256447.2621.75.camel@gandalf.local.home>
	 <CAFTL4hzXe=rYniSrth--n2Vp+wEYRt69r9+SPFu-Bac-_ZwM3Q@mail.gmail.com>
	 <0000013cb614e4e5-10f6e9ce-08e1-47f6-9044-565b4084c354-000000@email.amazonses.com>
	 <CAFTL4hyfnhjezjL2QfVKYDB-bwh4BSGyX8xmhpdmxTf+EAu+yA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-08 at 16:53 +0100, Frederic Weisbecker wrote:
> 2013/2/7 Christoph Lameter <cl@linux.com>:
> > On Thu, 7 Feb 2013, Frederic Weisbecker wrote:
> >
> >> Not with hrtick.
> >
> > hrtick? Did we not already try that a couple of years back and it turned
> > out that the overhead of constantly reprogramming a timer via the PCI bus
> > was causing too much of a performance regression?
> 
> Yeah Peter said that especially reprogramming the clock everytime we
> call schedule() was killing the performances. Now may be on some
> workloads, with the tick stopped, we can find some new results.

I could imagine this being dynamic. If the system isn't very loaded, and
the scheduler is giving lots of time slices to tasks, then perhaps it
could switch to a reprogramming the clock based scheduling. Or maybe, we
could switch to a "skip ticks" method. That is, instead of completely
disabling the tick, make the tick go off every other time or less, and
use the NO_HZ code to calculate the missed ticks.

-- Steve


