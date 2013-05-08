Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3EHUat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:30:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab3EHUas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:30:48 -0400
Date: Wed, 8 May 2013 16:30:42 -0400
From: Dave Jones <davej@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: rcu_preempt running flat out on idle desktop.
Message-ID: <20130508203042.GA18895@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On what should be an idle desktop, I'm seeing really strange things.

The XFCE CPU meter shows both cores are running with no idle time.

here's the top of the top(1) output..

  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND 
   10 root      20   0     0    0    0 S 200.0  0.0 185301:36 rcu_preempt                                                                                                                                       
  553 root      20   0  268m  76m 6764 S 200.0  2.6 144579:53 Xorg                                                                                                                                              
 1199 root      20   0     0    0    0 S 200.0  0.0 306:17.85 kworker/1:0                                                                                                                                       
  501 root      20   0     0    0    0 S 200.0  0.0   4471:03 kworker/0:2                                                                                                                                       
   12 root      20   0     0    0    0 S 200.0  0.0  67277:16 rcuop/1                                                                                                                                           
 1237 davej     20   0  535m  15m 8484 S 200.0  0.5   3645:16 Terminal                                                                                                                                          
  859 davej     20   0  117m 3036 1336 S 200.0  0.1   1986:55 htop          

There are a lot of processes allegedly using "200%" of CPU time, a handful
in the "196%" range, and then a bunch at 0.

rcu_preempt is staying at the top of the list while everything else bubbles
up the list.

And what's up with those TIME entries? Box has only been up a few hours,
so those numbers look really crazy.

RCU options for this build are..

CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_USER_QS=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y

	Dave

