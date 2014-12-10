Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbaLJXe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:34:59 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43296 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302AbaLJXe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:34:58 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: tglx@linutronix.de, hpa@zytor.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, luto@amacapital.net, JBeulich@suse.com,
        jgross@suse.com, bpoirier@suse.de, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 0/2] x86: add xen hypercall preemption
Date: Wed, 10 Dec 2014 15:34:45 -0800
Message-Id: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This is my second series which addresses hypercall preemption
on Xen. On the first iteration of this series [0] I tried as
much as possible to avoid cond_resched() type of behaviour
but after good feedback I've determined using something like
cond_resched() but on IRQ context is required for preempting
Xen hypercalls. This introduces and uses the new cond_resched_irq().

[0] https://lkml.org/lkml/2014/11/26/630

Luis R. Rodriguez (2):
  sched: add cond_resched_irq()
  x86/xen: allow privcmd hypercalls to be preempted

 arch/x86/kernel/entry_32.S | 21 +++++++++++++++++++++
 arch/x86/kernel/entry_64.S | 17 +++++++++++++++++
 drivers/xen/Makefile       |  2 +-
 drivers/xen/preempt.c      | 17 +++++++++++++++++
 drivers/xen/privcmd.c      |  2 ++
 include/linux/sched.h      |  7 +++++++
 include/xen/xen-ops.h      | 26 ++++++++++++++++++++++++++
 kernel/sched/core.c        | 10 ++++++++++
 8 files changed, 101 insertions(+), 1 deletion(-)
 create mode 100644 drivers/xen/preempt.c

-- 
2.1.1

