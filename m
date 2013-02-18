Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3BRPc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:32:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3BRPcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:32:55 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qKmpwTPKs3QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=nQirTONGrIgA:10 a=JHOO3Pfs48h6cxfrU7AA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361201574.23152.156.camel@gandalf.local.home>
Subject: Re: RCU?: Scheduling while atomic with 3.4.23-rt33
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Sander <tim.sander@hbm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2013 10:32:54 -0500
In-Reply-To: <alpine.LFD.2.02.1302181214250.22263@ionos>
References: <4738617.pBMCEJ5E3K@dabox>
	 <alpine.LFD.2.02.1302181214250.22263@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 12:16 +0100, Thomas Gleixner wrote:
> On Mon, 18 Feb 2013, Tim Sander wrote:
> > Here is a transtribed backtrace for easier reading:
> > c0010fac t dump_backtrace
> > c022c188 T dump_stack
> > c022c71c t __schedule_bug
> > c022fb28 t __schedule
> > c0230644 t rt_spin_lock_slowlock
> > c0230ba8 T rt_spin_lock
> > c003a9b8 T __wake_up
> > c0052a44 t invoke_rcu_callbacks
> > c0053764 T rcu_check_callbacks
> > c0026060 T update_process_times
> 
> That's due to CONFIG_TINY_PREEMPT_RCU=y. That's a known issue, which
> has been fixed in 3.6-rt.
> 
> Steven, could you backport that to 3.2/3.4 please ?
> 

I'm currently trying to get -rt up with the latest stable releases (Greg
is too damn fast). I'll add this in an -rc later today if I get a
chance. Otherwise it may have to wait till next week, or perhaps I can
work on it while at ELC (I leave tomorrow). Keynotes are always a good
time to get tedious tasks done online.

-- Steve


