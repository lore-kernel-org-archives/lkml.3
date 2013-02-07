Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab3BGRG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:06:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3BGRGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:06:23 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M5gr15I6uLgA:10 a=hfjD0w8Jl98efvhz1oQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360256781.2621.80.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 07 Feb 2013 12:06:21 -0500
In-Reply-To: <20130207163004.GS2632@linux.vnet.ibm.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	 <1360205415.2621.60.camel@gandalf.local.home>
	 <20130207111025.GD8945@gmail.com>
	 <1360253520.2621.66.camel@gandalf.local.home>
	 <20130207163004.GS2632@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 08:30 -0800, Paul E. McKenney wrote:

> I suspect that removal of jiffies from the kernel will take a few stages,
> with RCU being one of the laggards for awhile.  Making RCU's state
> machine depend wholly on process-based execution will take some care
> and experimentation, especially for extreme and corner-case workloads.
> For example, having RCU OOM the system just because a specific CPU was
> unable to run some RCU kthread for an extended time is something to
> be avoided.  ;-)

Tickless doesn't mean no timeouts or periodic timers. I think we will
always have some sort of dynamic tick when needed. It will just be more
event driven then something that goes off constantly.

-- Steve


