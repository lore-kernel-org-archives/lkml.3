Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaIKPLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:11:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaIKPLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:11:05 -0400
Date: Thu, 11 Sep 2014 11:10:40 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: futex_wait_setup sleeping while atomic bug.
Message-ID: <20140911151040.GB3008@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hit this overnight on Linus tree from yesterday.

BUG: sleeping function called from invalid context at include/linux/freezer.h:56
in_atomic(): 1, irqs_disabled(): 0, pid: 31948, name: trinity-c121
Preemption disabled at:[<ffffffffb90f2512>] futex_wait_setup+0xb2/0x140

CPU: 0 PID: 31948 Comm: trinity-c121 Not tainted 3.17.0-rc4+ #52
 ffffffffb9a52f2a 00000000d3f40479 ffff88008a32fd90 ffffffffb9771ba4
 0000000000000000 ffff88008a32fdb8 ffffffffb909f02c ffff88008a32ff58
 ffff88008a32ff58 0000000000000010 ffff88008a32fe30 ffffffffb90887bc
Call Trace:
 [<ffffffffb9771ba4>] dump_stack+0x4e/0x7a
 [<ffffffffb909f02c>] __might_sleep+0x11c/0x1b0
 [<ffffffffb90887bc>] get_signal+0x6c/0x720
 [<ffffffffb9002577>] do_signal+0x37/0x6f0
 [<ffffffffb9126ddb>] ? __acct_update_integrals+0x8b/0x120
 [<ffffffffb912728c>] ? acct_account_cputime+0x1c/0x20
 [<ffffffffb90ab1ab>] ? account_user_time+0x9b/0xb0
 [<ffffffffb9002c8c>] do_notify_resume+0x5c/0xa0
 [<ffffffffb977be23>] retint_signal+0x46/0x83
BUG: scheduling while atomic: trinity-c121/31948/0x00000002
Preemption disabled at:[<ffffffffb90f2512>] futex_wait_setup+0xb2/0x140

CPU: 0 PID: 31948 Comm: trinity-c121 Not tainted 3.17.0-rc4+ #52
 ffff88024d013740 00000000d3f40479 ffff88008a32fec8 ffffffffb9771ba4
 ffff8802403eee00 ffff88008a32fee0 ffffffffb909e725 0000000000000000
 ffff88008a32ff60 ffffffffb9774db7 000000000000a000 ffff8802403eee00
Call Trace:
 [<ffffffffb9771ba4>] dump_stack+0x4e/0x7a
 [<ffffffffb909e725>] __schedule_bug+0x65/0xc0
 [<ffffffffb9774db7>] __schedule+0x6a7/0xa70
 [<ffffffffb97756ee>] schedule_user+0x2e/0x90
 [<ffffffffb977bdc1>] retint_careful+0x12/0x2e
note: trinity-c121[31948] exited with preempt_count 1

