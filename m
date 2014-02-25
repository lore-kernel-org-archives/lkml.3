Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaBYElJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:41:09 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46987 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaBYElH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:41:07 -0500
Date: Mon, 24 Feb 2014 20:41:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, Ingo Molnar <mingo@redhat.com>,
        acme@ghostprotocols.net, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: tip/master show panic while booting/rebooting
Message-ID: <20140225044100.GL8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5302EBA3.10909@linux.vnet.ibm.com>
 <20140225003048.GJ8264@linux.vnet.ibm.com>
 <530C03C6.9080405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530C03C6.9080405@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022504-6688-0000-0000-000006F30C41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 10:45:26AM +0800, Michael wang wrote:
> Hi, Paul
> 
> On 02/25/2014 08:30 AM, Paul E. McKenney wrote:
> [snip]
> > 
> > I don't see an opportunity for load_balance() to loop with interrupts
> > disabled, but maybe I am looking at the wrong code.  The NMI handler
> > looks to me like it is diagnosing rather than being the problem.
> 
> Thanks for the comment :)
> 
> It was a stuck inside pick_next_task_fair(), and we already got one
> solution now ;-)

What I get for too-late reply.  Glad it is fixed!

							Thanx, Paul

> Regards,
> Michael Wang
> 
> > 
> > 							Thanx, Paul
> > 
> >>  [<ffffffff8108a88f>] idle_balance+0x10f/0x1c0
> >>  [<ffffffff8108aa5e>] pick_next_task_fair+0x11e/0x2a0
> >>  [<ffffffff8107bbf3>] ? dequeue_task+0x73/0x90
> >>  [<ffffffff815717fa>] __schedule+0x12a/0x670
> >>  [<ffffffff81571e19>] schedule+0x29/0x70
> >>  [<ffffffff81067daf>] worker_thread+0x1bf/0x370
> >>  [<ffffffff81067bf0>] ? manage_workers+0x160/0x160
> >>  [<ffffffff8106e799>] kthread+0xc9/0xe0
> >>  [<ffffffff8106e6d0>] ? flush_kthread_worker+0xb0/0xb0
> >>  [<ffffffff8157d62c>] ret_from_fork+0x7c/0xb0
> >>  [<ffffffff8106e6d0>] ? flush_kthread_worker+0xb0/0xb0
> >> Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 

