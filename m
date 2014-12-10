Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaLJMwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:52:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbaLJMwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:52:06 -0500
Date: Wed, 10 Dec 2014 13:52:02 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: rcu_sched stall detected, but no state dump
Message-ID: <alpine.LNX.2.00.1412101334380.22639@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1678380546-1041685850-1418215923=:22639"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-1041685850-1418215923=:22639
Content-Type: TEXT/PLAIN; charset=US-ASCII


Hi,

today I came across RCU stall which was correctly detected, but there is 
no state dump. This is a bit suspicious, I think. 

This is the output in serial console:

[  105.727003] INFO: rcu_sched detected stalls on CPUs/tasks:
[  105.727003]  (detected by 0, t=21002 jiffies, g=3269, c=3268, q=138)
[  105.727003] INFO: Stall ended before state dump start
[  168.732006] INFO: rcu_sched detected stalls on CPUs/tasks:
[  168.732006]  (detected by 0, t=84007 jiffies, g=3269, c=3268, q=270)
[  168.732006] INFO: Stall ended before state dump start
[  231.737003] INFO: rcu_sched detected stalls on CPUs/tasks:
[  231.737003]  (detected by 0, t=147012 jiffies, g=3269, c=3268, q=388)
[  231.737003] INFO: Stall ended before state dump start
[  294.742003] INFO: rcu_sched detected stalls on CPUs/tasks:
[  294.742003]  (detected by 0, t=210017 jiffies, g=3269, c=3268, q=539)
[  294.742003] INFO: Stall ended before state dump start
[  357.747003] INFO: rcu_sched detected stalls on CPUs/tasks:
[  357.747003]  (detected by 0, t=273022 jiffies, g=3269, c=3268, q=693)
[  357.747003] INFO: Stall ended before state dump start
[  420.752003] INFO: rcu_sched detected stalls on CPUs/tasks:
[  420.752003]  (detected by 0, t=336027 jiffies, g=3269, c=3268, q=806)
[  420.752003] INFO: Stall ended before state dump start
...

It can be reproduced by trivial code attached to this mail (infinite 
loop in kernel thread created in kernel module). I have CONFIG_PREEMPT=n. 
The kernel thread is scheduled on the same CPU which causes soft lockup 
(reliably detected when lockup detector is on). There is certainly RCU 
stall, but I would expect a state dump. Is this an expected behaviour? 
Maybe I overlooked some config option, don't know.

I tested 3.18 and also next-20141210. If it is improper behaviour I could 
try to find a good kernel release and bisect it.

Best regards,
--
Miroslav Benes
SUSE Labs
--1678380546-1041685850-1418215923=:22639
Content-Type: TEXT/x-c++src; name=kthread_mod.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.1412101352020.22639@pobox.suse.cz>
Content-Description: 
Content-Disposition: attachment; filename=kthread_mod.c

I2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0KI2luY2x1ZGUgPGxpbnV4L2tl
cm5lbC5oPg0KI2luY2x1ZGUgPGxpbnV4L2t0aHJlYWQuaD4NCiNpbmNsdWRl
IDxsaW51eC9kZWxheS5oPg0KDQpzdGF0aWMgc3RydWN0IHRhc2tfc3RydWN0
ICp0ZXN0X3RocmVhZDsNCg0Kc3RhdGljIGludCB0ZXN0X3RocmVhZF9mbih2
b2lkICpkYXRhKQ0Kew0KCXdoaWxlICgxKSB7DQoJCWlmIChrdGhyZWFkX3No
b3VsZF9zdG9wKCkpDQoJCQlicmVhazsNCg0KLy8JCW1zbGVlcCgxMDAwKTsN
Cgl9DQoNCglyZXR1cm4gMDsNCn0NCg0Kc3RhdGljIGludCBfX2luaXQgdGVz
dF9tb2R1bGVfaW5pdCh2b2lkKQ0Kew0KCXRlc3RfdGhyZWFkID0ga3RocmVh
ZF9ydW4odGVzdF90aHJlYWRfZm4sIE5VTEwsICJ0ZXN0X3RocmVhZCIpOw0K
DQoJcmV0dXJuIDA7DQp9DQoNCnN0YXRpYyB2b2lkIF9fZXhpdCB0ZXN0X21v
ZHVsZV9jbGVhbnVwKHZvaWQpDQp7DQoJa3RocmVhZF9zdG9wKHRlc3RfdGhy
ZWFkKTsNCn0NCg0KbW9kdWxlX2luaXQodGVzdF9tb2R1bGVfaW5pdCk7DQpt
b2R1bGVfZXhpdCh0ZXN0X21vZHVsZV9jbGVhbnVwKTsNCg0KTU9EVUxFX0xJ
Q0VOU0UoIkdQTCIpOw0KDQoNCg==

--1678380546-1041685850-1418215923=:22639--
