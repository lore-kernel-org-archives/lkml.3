Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875Ab3HSPgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:36:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3HSPgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:36:20 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5QKzQgG3YlMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=SN36CqCs8AMA:10 a=FhzIJPXP4dQwPA4EjLsA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130819153530.409041534@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 11:35:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RT 0/3] rt/rcu/swait: Fix boot up when RCU NOCB_ALL is enabled
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas and Sebastian,

These three patches fixes the boot problem that Carsten was having
with 3.10-rt and RCU_NOCB_ALL

Steven Rostedt (3):
      rcu/swait: Fix RCU conversion of wake_up_all() to swait_wake()
      swait: Add memory barrier before checking list empty
      swait: Add smp_mb() after setting h->list

----
 kernel/rcutree_plugin.h |    2 +-
 kernel/wait-simple.c    |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)
