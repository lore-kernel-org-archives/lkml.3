Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3BEBWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:22:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14655 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3BEBWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:22:47 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-mX8_mtaSd8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=BnJ6rni4RVIA:10 a=pGLkceISAAAA:8 a=itILZPxQ1iPigVbMT0oA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360027363.5642.67.camel@gandalf.local.home>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 04 Feb 2013 20:22:43 -0500
In-Reply-To: <20130204172001.8bb358b0.akpm@linux-foundation.org>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
	 <20130204172001.8bb358b0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 17:20 -0800, Andrew Morton wrote:
> On Tue,  5 Feb 2013 01:51:18 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> >       printk: Wake up klogd using irq_work
> 
> That seems reasonable.
> 
> I'm wondering if we can now remove the printk_sched() special-case. 
> iirc, that was needed because wake_up(klogd) would deadlock when called
> from sched internals.  But now that wakeup is punted to the timer tick,
> perhaps this is now unnecessary?
> 
> (Maybe there were other problems, but the 3ccf3e8306 is poor, and its
> author is unavailable.  There's a lesson there!)

I think we can nuke it with the printk irq work. I'll start looking into
that.

Thanks!

-- Steve


