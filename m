Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3GCF2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 01:28:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3GCF2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 01:28:11 -0400
Date: Wed, 3 Jul 2013 01:28:01 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: arch/x86/include/asm/trace/irq_vectors.h:50 suspicious
 rcu_dereference_check() usage!
Message-ID: <20130703052801.GA2591@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 3206.433900] ===============================
[ 3206.434449] [ INFO: suspicious RCU usage. ]
[ 3206.434999] 3.10.0+ #40 Not tainted
[ 3206.435468] -------------------------------
[ 3206.436018] /home/davej/src/linux-dj/arch/x86/include/asm/trace/irq_vectors.h:50 suspicious rcu_dereference_check() usage!
[ 3206.437383] 
other info that might help us debug this:

[ 3206.438388] 
RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
[ 3206.439733] RCU used illegally from extended quiescent state!
[ 3206.440474] no locks held by trinity-child1/31470.
[ 3206.441096] 
stack backtrace:
[ 3206.441667] CPU: 3 PID: 31470 Comm: trinity-child1 Not tainted 3.10.0+ #40
[ 3206.445412]  0000000000000000 ffff880244e03f60 ffffffff816ec1a2 ffff880244e03f90
[ 3206.447288]  ffffffff810b8b07 ffff88022e069890 ffff880207809f58 0000000000000006
[ 3206.449335]  0000003e127b97d8 ffff880244e03fa8 ffffffff8102629e 0000000000000282
[ 3206.451405] Call Trace:
[ 3206.452676]  <IRQ>  [<ffffffff816ec1a2>] dump_stack+0x19/0x1b
[ 3206.454390]  [<ffffffff810b8b07>] lockdep_rcu_suspicious+0xe7/0x120
[ 3206.456086]  [<ffffffff8102629e>] smp_trace_reschedule_interrupt+0x17e/0x290
[ 3206.457876]  [<ffffffff8170022f>] trace_reschedule_interrupt+0x6f/0x80
[ 3206.459593]  <EOI>  [<ffffffff8114a847>] ? user_enter+0x87/0xd0
[ 3206.461279]  [<ffffffff816fa6c5>] do_page_fault+0x45/0x50
[ 3206.462872]  [<ffffffff816f6fe2>] page_fault+0x22/0x30

