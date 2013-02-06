Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab3BFE0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:26:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11908 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab3BFE0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:26:14 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=_Bp3_fu7e2UA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=wIfm1DkAj9kA:10 a=57ncc4E-udCjV0-8yi8A:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Tue, 5 Feb 2013 23:26:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
Message-ID: <20130206042611.GB9161@home.goodmis.org>
References: <5111AD8D.1080005@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5111AD8D.1080005@candelatech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 05:10:37PM -0800, Ben Greear wrote:
> 
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.7.6+ #4 Tainted: G         C O
> -------------------------------
> /home/greearb/git/linux-3.7.dev.y/kernel/rcutree.c:360 Illegal idle entry in RCU read-side critical section.!
> 
> other info that might help us debug this:
> 
> 
> RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 1
> RCU used illegally from extended quiescent state!
> 1 lock held by swapper/1/0:
>  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81489632>] rcu_read_lock+0x0/0x6f
> 
> stack backtrace:
> Pid: 0, comm: swapper/1 Tainted: G         C O 3.7.6+ #4
> Call Trace:
>  <IRQ>  [<ffffffff810cecbd>] lockdep_rcu_suspicious+0xfc/0x105
>  [<ffffffff810fe146>] rcu_eqs_enter_common+0xef/0x178
>  [<ffffffff810fe24e>] rcu_irq_exit+0x7f/0xb0
>  [<ffffffff8108edf5>] irq_exit+0xc0/0xcc
>  [<ffffffff8100b635>] do_IRQ+0x97/0xae
>  [<ffffffff815543b2>] common_interrupt+0x72/0x72
>  <EOI>  [<ffffffff81011082>] ? mwait_idle+0x77/0x9f
>  [<ffffffff81011079>] ? mwait_idle+0x6e/0x9f
>  [<ffffffff81011379>] cpu_idle+0x68/0xbc
>  [<ffffffff8154ce84>] start_secondary+0x1fc/0x203

BTW, did the above error only happen when you added the dump of the
locks, or was it always there? Is this the bug you were trying to debug?

-- Steve

