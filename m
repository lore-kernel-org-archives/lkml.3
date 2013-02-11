Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3BKJ7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:59:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39223 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab3BKJ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:59:14 -0500
Date: Mon, 11 Feb 2013 10:59:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
Message-ID: <20130211095909.GG23932@gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
 <1360205415.2621.60.camel@gandalf.local.home>
 <20130207111025.GD8945@gmail.com>
 <CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
 <20130207190754.GB25223@gmail.com>
 <CAFTL4hwKzcNEr8G1h1SErhwxAuQKR3rEX3cxxCyxf_LFHudL0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hwKzcNEr8G1h1SErhwxAuQKR3rEX3cxxCyxf_LFHudL0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > I'm worried about the proliferation of not easily separable 
> > config options. We already have way too many timer and 
> > scheduler options to begin with.
> 
> Like Steve said, this is for overhead reasons. The syscall 
> uses the slow path so that's ok. But we add a callback to 
> every exception, irq entry/exit, scheduler sched switch, 
> signal handling, user and kernel preemption point. This all 
> could be lowered using static keys but even that doesn't make 
> me feel comfortable with this idea.
> 
> Moreover, for now this is going to be used only on extreme 
> usecases such as real time and HPC. If we really have to merge 
> this into an all-in-one nohz kconfig, I suggest we wait for 
> the feature to mature a bit and prove that it can be useful 
> further those specialized workloads, and also that we can 
> ensure it's off-case overhead is not significant.

I have no problems with making it an option initially - as long 
as the options are logically named and interconnected.

In terms of overhead, a big plus is the reduction in user-space 
execution overhead. At HZ=1000 we easily have 0.5%-1.0% overhead 
currently. That is a *lot* of overhead if the box does mostly 
user-space execution - which most boxes do, both servers and 
desktops - not HPC systems.

Thanks,

	Ingo
