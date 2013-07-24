Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3GXOUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:20:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45891 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433Ab3GXOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Will Deacon" <will.deacon@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Jed Davis" <jld@mozilla.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.482089959@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [34/85] ARM: 7765/1: perf: Record the user-mode PC in the call chain.
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jed Davis <jld@mozilla.com>

commit c5f927a6f62196226915f12194c9d0df4e2210d7 upstream.

With this change, we no longer lose the innermost entry in the user-mode
part of the call chain.  See also the x86 port, which includes the ip.

It's possible to partially work around this problem by post-processing
the data to use the PERF_SAMPLE_IP value, but this works only if the CPU
wasn't in the kernel when the sample was taken.

Signed-off-by: Jed Davis <jld@mozilla.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/perf_event.c | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -795,6 +795,7 @@ perf_callchain_user(struct perf_callchai
 	struct frame_tail __user *tail;
 
 
+	perf_callchain_store(entry, regs->ARM_pc);
 	tail = (struct frame_tail __user *)regs->ARM_fp - 1;
 
 	while ((entry->nr < PERF_MAX_STACK_DEPTH) &&

