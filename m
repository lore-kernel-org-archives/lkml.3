Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaCaXCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaCaXCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:02:51 -0400
Date: Mon, 31 Mar 2014 19:02:41 -0400
From: Dave Jones <davej@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: rcu_prempt stalls / lockup
Message-ID: <20140331230241.GA30019@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can tell the merge window is open, because I'm back to breaking RCU.

[ 1023.934532] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1023.935501]  (detected by 0, t=6502 jiffies, g=28666, c=28665, q=0)
[ 1023.936299] INFO: Stall ended before state dump start
[ 1218.871404] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1218.872399]  (detected by 0, t=26007 jiffies, g=28666, c=28665, q=0)
[ 1218.873256] INFO: Stall ended before state dump start
[ 1413.808406] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1413.809387]  (detected by 0, t=45512 jiffies, g=28666, c=28665, q=0)
[ 1413.810113] INFO: Stall ended before state dump start
[ 1608.745637] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1608.746614]  (detected by 0, t=65017 jiffies, g=28666, c=28665, q=0)
[ 1608.747327] INFO: Stall ended before state dump start
[ 1803.682892] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1803.683876]  (detected by 1, t=84522 jiffies, g=28666, c=28665, q=0)
[ 1803.684741] INFO: Stall ended before state dump start
[ 1998.620169] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1998.621123]  (detected by 0, t=104027 jiffies, g=28666, c=28665, q=0)
[ 1998.621916] INFO: Stall ended before state dump start
[ 2193.557459] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2193.558425]  (detected by 0, t=123532 jiffies, g=28666, c=28665, q=0)
[ 2193.559248] INFO: Stall ended before state dump start
[ 2388.494719] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2388.495688]  (detected by 0, t=143037 jiffies, g=28666, c=28665, q=0)
[ 2388.496417] INFO: Stall ended before state dump start
[ 2583.431983] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2583.432967]  (detected by 0, t=162542 jiffies, g=28666, c=28665, q=0)
[ 2583.433852] INFO: Stall ended before state dump start
[ 2778.369242] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2778.370235]  (detected by 0, t=182047 jiffies, g=28666, c=28665, q=0)
[ 2778.371037] INFO: Stall ended before state dump start
[ 2973.306537] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2973.307540]  (detected by 0, t=201552 jiffies, g=28666, c=28665, q=0)
[ 2973.308347] INFO: Stall ended before state dump start
[ 3168.244036] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 3168.245056]  (detected by 0, t=221057 jiffies, g=28666, c=28665, q=0)
[ 3168.245805] INFO: Stall ended before state dump start
[ 3363.181458] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 3363.182496]  (detected by 0, t=240562 jiffies, g=28666, c=28665, q=0)
[ 3363.183289] INFO: Stall ended before state dump start
[ 3558.118835] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 3558.119879]  (detected by 0, t=260067 jiffies, g=28666, c=28665, q=0)
[ 3558.120739] INFO: Stall ended before state dump start

at that point, userspace stopped responding. cursor on console was blinking,
but I couldn't even switch tty's, or sysrq dump.

rc8 was fine, so this is todays rcu changes.

	Dave

