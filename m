Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555AbaLLSnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:43:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933905AbaLLSnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:43:31 -0500
Date: Fri, 12 Dec 2014 13:42:48 -0500
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141212184248.GA4716@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212030343.GA7945@redhat.com>
 <20141212044509.GA21145@redhat.com>
 <20141212181044.GW25340@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212181044.GW25340@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 10:10:44AM -0800, Paul E. McKenney wrote:

 > > [18801.941908] INFO: rcu_preempt detected stalls on CPUs/tasks:
 > > [18801.942920] 	3: (3 GPs behind) idle=bf4/0/0 softirq=1597256/1597257 
 > > [18801.943890] 	(detected by 0, t=6002 jiffies, g=763359, c=763358, q=0)
 > > [18801.944843] Task dump for CPU 3:
 > > [18801.945770] swapper/3       R  running task    14576     0      1 0x00200000
 > > [18801.946706]  0000000342b6fe28 def23185c07e1b3d ffffe8ffff403518 0000000000000001
 > > [18801.947629]  ffffffff81cb2000 0000000000000003 ffff880242b6fe78 ffffffff8166cb95
 > > [18801.948557]  0000111242adb59f ffffffff81cb2070 ffff880242b6c000 ffffffff81d21ab0
 > > [18801.949478] Call Trace:
 > > [18801.950384]  [<ffffffff8166cb95>] ? cpuidle_enter_state+0x55/0x1c0
 > > [18801.951303]  [<ffffffff8166cdb7>] ? cpuidle_enter+0x17/0x20
 > > [18801.952211]  [<ffffffff810bf303>] ? cpu_startup_entry+0x423/0x4d0
 > > [18801.953125]  [<ffffffff810314c3>] ? start_secondary+0x1a3/0x220
 > 
 > Very strange.  Both cpuidle_enter() and cpuidle_enter_state() should be
 > within the idle loop, so that RCU should be ignoring this CPU.  And the
 > "idle=bf4/0/0" means that it really has marked itself as being idle from
 > an RCU perspective.  So I am guessing that the RCU grace-period kthread
 > has not gotten a chance to run.
 > 
 > If you are willing to live a bit dangerously, could you please see if
 > the (not for mainline) patch below clears this up?

I'll try anything at this point, regardless of danger level :)

	Dave

