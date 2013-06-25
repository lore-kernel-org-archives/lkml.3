Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3FYTPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:15:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FYSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jed Davis <jld@mozilla.com>, Ingo Molnar <mingo@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 03/95] perf: arm64: Record the user-mode PC in the call chain.
Date: Tue, 25 Jun 2013 11:31:50 -0700
Message-Id: <20130625182154.049293865@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jed Davis <jld@mozilla.com>

commit abc41254181e901ef5eda2c884ca6cd88a186b6d upstream.

With this change, we no longer lose the innermost entry in the user-mode
part of the call chain.  See also the x86 port, which includes the ip,
and the corresponding change in arch/arm.

Signed-off-by: Jed Davis <jld@mozilla.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/perf_event.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -1336,6 +1336,7 @@ void perf_callchain_user(struct perf_cal
 		return;
 	}
 
+	perf_callchain_store(entry, regs->pc);
 	tail = (struct frame_tail __user *)regs->regs[29];
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH &&


