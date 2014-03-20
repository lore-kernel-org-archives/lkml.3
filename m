Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaCTFeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:34:01 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37432 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaCTFeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:34:00 -0400
Date: Thu, 20 Mar 2014 11:03:50 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: davidlohr@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        paulus@samba.org, Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
Message-ID: <20140320053350.GB30295@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140319170829.GD8557@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032005-3568-0000-0000-000005209524
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Joy,.. let me look at that with ppc in mind.
> 
> OK; so while pretty much all the comments from that patch are utter
> nonsense (what was I thinking), I cannot actually find a real bug.
> 
> But could you try the below which replaces a control dependency with a
> full barrier. The control flow is plenty convoluted that I think the
> control barrier isn't actually valid anymore and that might indeed
> explain the fail.
> 

Unfortunately the patch didnt help. Still seeing tasks stuck

# ps -Ao pid,tt,user,fname,tmout,f,wchan | grep futex
14680 pts/0    root     java         - 0 futex_wait_queue_me
14797 pts/0    root     java         - 0 futex_wait_queue_me
# :> /var/log/messages
# echo t > /proc/sysrq-trigger 
# grep futex_wait_queue_me /var/log/messages | wc -l 
334
#

[ 6904.211478] Call Trace:
[ 6904.211481] [c000000fa1f1b4d0] [0000000000000020] 0x20 (unreliable)
[ 6904.211486] [c000000fa1f1b6a0] [c000000000015208] .__switch_to+0x1e8/0x330
[ 6904.211491] [c000000fa1f1b750] [c000000000702f00] .__schedule+0x360/0x8b0
[ 6904.211495] [c000000fa1f1b9d0] [c000000000147348] .futex_wait_queue_me+0xf8/0x1a0
[ 6904.211500] [c000000fa1f1ba60] [c0000000001486dc] .futex_wait+0x17c/0x2a0
[ 6904.211505] [c000000fa1f1bc10] [c00000000014a614] .do_futex+0x254/0xd80
[ 6904.211510] [c000000fa1f1bd60] [c00000000014b25c] .SyS_futex+0x11c/0x1d0
[ 6904.238874] [c000000fa1f1be30] [c00000000000a0fc] syscall_exit+0x0/0x7c
[ 6904.238879] java            S 00003fff825f6044     0 14682  14076 0x00000080

Is there any other information that I provide that can help?

-- 
Thanks and Regards
Srikar Dronamraju

