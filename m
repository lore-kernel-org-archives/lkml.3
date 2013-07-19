Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216Ab3GSC00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:26:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935039Ab3GSCZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:25:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jed Davis <jld@mozilla.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 22/24] ARM: 7765/1: perf: Record the user-mode PC in the call chain.
Date: Thu, 18 Jul 2013 19:24:54 -0700
Message-Id: <20130719022405.535216352@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719022404.015008451@linuxfoundation.org>
References: <20130719022404.015008451@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -824,6 +824,7 @@ perf_callchain_user(struct perf_callchai
 	struct frame_tail __user *tail;
 
 
+	perf_callchain_store(entry, regs->ARM_pc);
 	tail = (struct frame_tail __user *)regs->ARM_fp - 1;
 
 	while ((entry->nr < PERF_MAX_STACK_DEPTH) &&


