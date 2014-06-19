Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091AbaFSQk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:40:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:11735 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933683AbaFSQkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:40:53 -0400
Date: Thu, 19 Jun 2014 12:40:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [tracing] 939c7a4f04f: -46.4% cpuidle.C3-IVT.time
Message-ID: <20140619124051.1af1d777@gandalf.local.home>
In-Reply-To: <20140619162842.GB10268@localhost>
References: <53A10460.1040705@intel.com>
	<53A27D66.6070409@hitachi.com>
	<20140619162842.GB10268@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014 00:28:42 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> Hi Yoshihiro,
> 
> On Thu, Jun 19, 2014 at 03:04:22PM +0900, Yoshihiro YUNOMAE wrote:
> > Hi Jet,
> > 
> > Thank you for your report.
> > I have some questions for your test.
> > 
> > 1. Did you enable ftrace?
> 
> Yes, ftrace is enabled. Attached is the kernel config.

I guess the question isn't about enabling it in the kernel, but
actually enabling the tracing itself at runtime.

Just enabling it in the kernel, still does not make this code executed.

> 
> > This patch added a feature for ftrace. If you disabled ftrace in
> > this test, my patch will not affect the system. Moreover, in my patch,
> > arrays for saved_cmdlines were just changed from using static global
> > variables to using kmalloc() on default setting. So, even if you enabled
> > ftrace, this patch will not induce a big problem, I think.
> 
> Agreed, the patch itself looks good. Unfortunately sometimes a small
> change in one place may lead to subtle changes in other places due to
> data alignment etc. effects.

There's nothing we can do to change that. We were lucky that we had
some data alignment that gave us an improvement. But that's it. Shear
luck! This isn't the fault of the patch then, it's the linker and
compiler that you need to take issue with.
 
> 
> > 2. How did you test it and what does the result mean?
> > Please tell me the workload, how to calculate the score,
> > system settings, etc...
> 
> Workload is aim7's brk_test case, running on an Ivy Bridge-EX machine.
> However it's not aim7's throughput that's regressed, but there are
> changes in the C3 state, number of RCU softirqs and power consumption
> etc.

This is still rather weird. As if tracing wasn't happening, then this
should not have had any affect at all. I mean really? The patch just
changes some local code to kernel/trace/trace.c, which is not even
remotely related to RCU softirqs or power consumption. It's dead code
as far as you are concerned (unless you enabled running some tracing).

-- Steve
