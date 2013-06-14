Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3FNPfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:35:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16364 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3FNPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:35:52 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=tkaDFPjYVEIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=apdwqXrHFoAA:10 a=cGvrsGG1Lldk8p6T-csA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371224150.9844.327.camel@gandalf.local.home>
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
From: Steven Rostedt <rostedt@goodmis.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Date: Fri, 14 Jun 2013 11:35:50 -0400
In-Reply-To: <20130614134947.GB133453@redhat.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
	 <1371045758-5296-5-git-send-email-fweisbec@gmail.com>
	 <20130612170316.GO133453@redhat.com> <20130613131057.GA15997@somewhere>
	 <20130613140207.GW133453@redhat.com> <20130613142210.GD16339@somewhere>
	 <20130613144515.GX133453@redhat.com> <20130613145601.GE16339@somewhere>
	 <20130613152059.GA133453@redhat.com>
	 <1371138491.9844.288.camel@gandalf.local.home>
	 <20130614134947.GB133453@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 09:49 -0400, Don Zickus wrote:
>  
> > The concept behind full dynamic ticks is very easy. When you set a given
> > CPU(s) to dynamic tick, when it only has a single task scheduled on that
> > CPU, it disables the periodic tick. This removes essentially *all*
> > latency from the kernel! That is, if the task is doing some complex
> 
> Including SMMi latency? ;-)

When you have SMI latencies, it's time to bitch at your vendor, not
us. ;-)


> > 
> > Now removing the periodic tick is not a trivial task, and this is where
> > all our issues come from. In fact, we can not even completely remove the
> > tick yet, we just move it to 1 HZ instead of whatever the CONFIG_HZ is
> > set to. We have to handle everything that depends on that tick, which
> > includes perf, among other things.
> 
> Which part of perf is dependent on the tick?  Just curious.

I'm not the one to answer this question, but it seems that it uses the
tick whenever perf is active. I had to disable watchdog when dynamic
tick was configured because it would permanently disable dynamic ticks
without letting the user know why. This is because watchdog uses perf
and enables it on boot and keeps it enabled.

-- Steve


