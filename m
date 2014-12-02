Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbaLBWB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:01:57 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56197 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbaLBWBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:01:55 -0500
Message-ID: <547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
Date: Tue, 2 Dec 2014 20:01:49 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141202205636.GQ25340@linux.vnet.ibm.com>
References: <20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
	<547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 12:56:36 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> And I left out a step.  Let's make sure that my preempt_disabled() hack
> to CONFIG_TREE_PREEMPT_RCU=y has the same effect as the Kconfig hack
> that allowed CONFIG_PREEMPT=y and CONFIG_TREE_PREEMPT_RCU=n.  Could you
> please try out the following patch configured with CONFIG_PREEMPT=y
> and CONFIG_TREE_PREEMPT_RCU=y?

	Of course! I applied your patch to 3.17 stock kernel and after
stressing it (compiling with -j8 and watching videos on Youtube) to
trigger the bug I got the following:

Dec  2 19:47:25 tux kernel: [  927.973547] INFO: rcu_preempt detected stalls on CPUs/tasks: { 5} (detected by 1, t=60002 jiffies, g=71142, c=71141, q=0)
Dec  2 19:47:26 tux kernel: [  927.973553] Task dump for CPU 5:
Dec  2 19:47:26 tux kernel: [  927.973555] cc1             R  running task        0 30691  30680 0x00080008
Dec  2 19:47:26 tux kernel: [  927.973558]  ffff88021f351bc0 ffff8801d5743f00 ffffffff8107062a ffff88021f351c38
Dec  2 19:47:26 tux kernel: [  927.973560]  ffff8801d5743ea8 ffff8800cd3b0000 ffff8800cd3b041c 0000000000000000
Dec  2 19:47:26 tux kernel: [  927.973562]  00007f89b4d7d8e8 00007f89b5939a60 ffff88021f34d2c0 00007f89b4d7f000
Dec  2 19:47:26 tux kernel: [  927.973564] Call Trace:
Dec  2 19:47:26 tux kernel: [  927.973573]  [<ffffffff8107062a>] ? pick_next_task_fair+0x6aa/0x890
Dec  2 19:47:26 tux kernel: [  927.973577]  [<ffffffff81087483>] ? rcu_eqs_enter+0x93/0xa0
Dec  2 19:47:26 tux kernel: [  927.973579]  [<ffffffff81087f2e>] ? rcu_user_enter+0xe/0x10
Dec  2 19:47:26 tux kernel: [  927.973582]  [<ffffffff8103935a>] ? do_page_fault+0x5a/0x70
Dec  2 19:47:26 tux kernel: [  927.973585]  [<ffffffff8139bed2>] ? page_fault+0x22/0x30
Dec  2 19:47:30 tux kernel: [  932.471964] CPU1: Core temperature above threshold, cpu clock throttled (total events = 820)
Dec  2 19:47:30 tux kernel: [  932.471966] CPU6: Package temperature above threshold, cpu clock throttled (total events = 2624)
Dec  2 19:47:30 tux kernel: [  932.471967] CPU3: Package temperature above threshold, cpu clock throttled (total events = 2624)
Dec  2 19:47:30 tux kernel: [  932.471968] CPU7: Package temperature above threshold, cpu clock throttled (total events = 2624)
Dec  2 19:47:30 tux kernel: [  932.471969] CPU0: Package temperature above threshold, cpu clock throttled (total events = 2624)
Dec  2 19:47:30 tux kernel: [  932.471970] CPU2: Package temperature above threshold, cpu clock throttled (total events = 2624)
Dec  2 19:47:30 tux kernel: [  932.471978] CPU1: Package temperature above threshold, cpu clock throttled (total events = 2624)
Dec  2 19:47:30 tux kernel: [  932.472922] CPU1: Core temperature/speed normal
Dec  2 19:47:30 tux kernel: [  932.472923] CPU6: Package temperature/speed normal
Dec  2 19:47:31 tux kernel: [  932.472923] CPU2: Package temperature/speed normal
Dec  2 19:47:31 tux kernel: [  932.472924] CPU3: Package temperature/speed normal
Dec  2 19:47:31 tux kernel: [  932.472925] CPU0: Package temperature/speed normal

	Waiting for your next instructions.

-- 
Linux 3.17.0-dirty: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
