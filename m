Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3LPEIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:08:31 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47551 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3LPEIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:08:04 -0500
From: Allen Pais <allen.pais@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org, bigeasy@linutronix.de,
        Allen Pais <allen.pais@oracle.com>
Subject: [PATCH 1/3] sparc64: use generic rwsem spinlocks rt
Date: Mon, 16 Dec 2013 09:37:31 +0530
Message-Id: <1387166853-10782-2-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387166853-10782-1-git-send-email-allen.pais@oracle.com>
References: <1387166853-10782-1-git-send-email-allen.pais@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Allen Pais <allen.pais@oracle.com>
---
 arch/sparc/Kconfig |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6787bd3..554995d 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -179,12 +179,10 @@ config NR_CPUS
 source kernel/Kconfig.hz
 
 config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y if SPARC32
+	def_bool PREEMPT_RT_FULL
 
 config RWSEM_XCHGADD_ALGORITHM
-	bool
-	default y if SPARC64
+	def_bool !RWSEM_GENERIC_SPINLOCK && !PREEMPT_RT_FULL
 
 config GENERIC_HWEIGHT
 	bool
-- 
1.7.10.4

