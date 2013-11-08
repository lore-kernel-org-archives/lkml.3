Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab3KHXKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:10:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36696 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459Ab3KHXKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:10:16 -0500
Date: Fri, 8 Nov 2013 15:09:53 -0800
From: tip-bot for Seiji Aguchi <tipbot@zytor.com>
Message-ID: <tip-959c071f0974cda7702d7574647de7ad9259eb57@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <52716DB8.1080702@hds.com>
References: <52716DB8.1080702@hds.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trace] x86, trace: Remove __alloc_intr_gate()
Git-Commit-ID: 959c071f0974cda7702d7574647de7ad9259eb57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 08 Nov 2013 15:09:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  959c071f0974cda7702d7574647de7ad9259eb57
Gitweb:     http://git.kernel.org/tip/959c071f0974cda7702d7574647de7ad9259eb57
Author:     Seiji Aguchi <seiji.aguchi@hds.com>
AuthorDate: Wed, 30 Oct 2013 16:36:08 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 8 Nov 2013 14:15:44 -0800

x86, trace: Remove __alloc_intr_gate()

Prepare to move set_intr_gate() into a macro by removing
__alloc_intr_gate().

The purpose is to avoid failing a kernel build after applying a
subsequent patch which changes set_intr_gate() into a macro.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Link: http://lkml.kernel.org/r/52716DB8.1080702@hds.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/desc.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index b90e5df..d939567 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -395,15 +395,10 @@ static inline void trace_set_intr_gate(unsigned int gate, void *addr)
 #define __trace_alloc_intr_gate(n, addr)
 #endif
 
-static inline void __alloc_intr_gate(unsigned int n, void *addr)
-{
-	set_intr_gate(n, addr);
-}
-
 #define alloc_intr_gate(n, addr)				\
 	do {							\
 		alloc_system_vector(n);				\
-		__alloc_intr_gate(n, addr);			\
+		set_intr_gate(n, addr);				\
 		__trace_alloc_intr_gate(n, trace_##addr);	\
 	} while (0)
 
