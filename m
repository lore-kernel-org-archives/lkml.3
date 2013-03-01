Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3CAQjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:39:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab3CAQjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:39:16 -0500
From: "Richard W.M. Jones" <rjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rjones@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, len.brown@intel.com, wangyun@linux.vnet.ibm.com
Subject: [PATCH] x86: Expose loops_per_jiffy through /proc/cpuinfo.
Date: Fri,  1 Mar 2013 16:38:43 +0000
Message-Id: <1362155923-884-1-git-send-email-rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Richard W.M. Jones" <rjones@redhat.com>

When we run the current kernel using qemu with TCG (software emulation
of x86), adding the lpj= option to the guest kernel helps greatly with
clock stability especially when the host is heavily loaded.

Currently the calculated 'lpj=...' argument is printed by the kernel
during boot, but isn't available after boot (eg. if boot messages have
scrolled off the kernel message ring).  It is also not possible to
calculate lpj from available information, especially as non-root.

This adds lpj to /proc/cpuinfo information so it is always available.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 arch/x86/kernel/cpu/proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index e280253..bf9c2e8 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -103,6 +103,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);
+	seq_printf(m, "lpj\t\t: %lu\n", c->loops_per_jiffy);
 
 #ifdef CONFIG_X86_64
 	if (c->x86_tlbsize > 0)
-- 
1.8.1.2

