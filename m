Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab3ELIRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 04:17:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51592 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3ELIRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 04:17:53 -0400
Message-ID: <1368346669.5998.13.camel@marge.simpson.net>
Subject: dynticks: CONFIG_VIRT_CPU_ACCOUNTING +  CONFIG_CONTEXT_TRACKING
 breaks accounting on core2 CPUs only
From: Mike Galbraith <bitbucket@online.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sun, 12 May 2013 10:17:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:rhaMxfNFygn4GgiZ2PYLJgyHi73O9eWVR/MQPChJa+O
 B0v28jvtdRE3X6nhOJKEY8MW6c/fI6FyaGke6S45AUjttT1znt
 sIX0F2ndkhT8pU8a2BxLzRCcPhAs/XwtsHKlZULVLLkjMlfVf0
 qbIpInq/VASy//acKOLWdQph37RH9CVz7+p7cI6uphgVyiGgsp
 84gWBEPa76pwRFrILgyan29UD+KgXTK2jQgSmw/okBZhr+UoqX
 CVkFHjgQQhW0vEzFYdjMFRCFH4rD8mPYvF4/raH/hAHthrox0Q
 53PYiE0R0lAbCjr2lVm27+ztZW6w01vGJVxBints6sNPyumyxy
 pwtzVUkKXc8hn3Db5tvrA7NCMGVZmjKXfS0rUmmNEsVKLF4JNX
 41Mc0n0wYPoCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Turning on new NO_HZ feature on my Q6600 box in master, I see that tasks
accrue zero utime/stime.  However, the same exact kernel on E5620 box
works fine, so it would appear there's a CPU dependency somewhere.

Is core2 expected to go dysfunctional with context tracking enabled?
CONFIG_VIRT_CPU_ACCOUNTING alone works fine in 3.9-stable, turn on
CONFIG_CONTEXT_TRACKING_FORCE, and CPU accounting stops working on core2
boxen only, same exact kernel continues to work just fine on E5620
(Westmere) box.

-Mike 

marge:/usr/local/src/kernel/linux-3.9 # egrep 'NO_HR|CPU_ACCOUNTING|RCU|
CONTEXT' .config
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# RCU Subsystem
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_RCU_USER_QS is not set
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
# RCU Debugging
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
CONFIG_CONTEXT_SWITCH_TRACER=y

