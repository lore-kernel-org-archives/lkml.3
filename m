Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaHFSSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:18:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317AbaHFSSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:18:16 -0400
Date: Wed, 6 Aug 2014 14:18:01 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: paulmck@linux.vnet.ibm.com, dave@sr71.net
Subject: suspicious RCU usage. (TLB flush tracepoints)
Message-ID: <20140806181801.GA4605@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	paulmck@linux.vnet.ibm.com, dave@sr71.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

===============================
[ INFO: suspicious RCU usage. ]
3.16.0+ #34 Not tainted
-------------------------------
include/trace/events/tlb.h:35 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
RCU used illegally from extended quiescent state!
no locks held by swapper/1/0.

stack backtrace:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.16.0+ #34
 0000000000000001 e7d0f46a57e60fc7 ffff880243357db0 ffffffff8a7f1e37
 ffff880243360000 ffff880243357de0 ffffffff8a0cc6c5 ffff8801753693f8
 ffff88023e2e2a40 0000000000000001 ffff88023e2e2a40 ffff880243357e10
Call Trace:
 [<ffffffff8a7f1e37>] dump_stack+0x4e/0x7a
 [<ffffffff8a0cc6c5>] lockdep_rcu_suspicious+0xd5/0x110
 [<ffffffff8a049f05>] leave_mm+0x1a5/0x200
 [<ffffffff8a3ec8df>] intel_idle+0x16f/0x190
 [<ffffffff8a6623da>] cpuidle_enter_state+0x3a/0xd0
 [<ffffffff8a662557>] cpuidle_enter+0x17/0x20
 [<ffffffff8a0c719c>] cpu_startup_entry+0x43c/0x800
 [<ffffffff8a03232d>] start_secondary+0x29d/0x3b0


Looks like this came from the addition of trace points in d17d8f9de

	Dave

