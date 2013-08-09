Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966835Ab3HILve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:51:34 -0400
Received: from cryptobitch.de ([88.198.7.68]:33632 "EHLO mail.cryptobitch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965439Ab3HILvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:51:32 -0400
X-Greylist: delayed 725 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Aug 2013 07:51:32 EDT
From: Tobias Mueller <muelli@cryptobitch.de>
To: Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tobias Mueller <muelli@cryptobitch.de>
Subject: [PATCH] arm: Fix is_gate_vma to have a == instead of a single =
Date: Fri,  9 Aug 2013 13:39:21 +0200
Message-Id: <1376048361-25836-1-git-send-email-muelli@cryptobitch.de>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A typo was introduced when merging the "security-fixes" branch which made the
comparison an assignment.
---
 arch/arm/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 536c85f..94f6b05 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -462,7 +462,7 @@ int in_gate_area_no_mm(unsigned long addr)
 {
 	return in_gate_area(NULL, addr);
 }
-#define is_gate_vma(vma)	((vma) = &gate_vma)
+#define is_gate_vma(vma)	((vma) == &gate_vma)
 #else
 #define is_gate_vma(vma)	0
 #endif
-- 
1.7.8.6

