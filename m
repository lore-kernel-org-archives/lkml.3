Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaAFDzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:55:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18053 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaAFDzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:55:38 -0500
From: Allen Pais <allen.pais@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org, davem@davemloft.net, bigeasy@linutronix.de,
        Allen Pais <allen.pais@oracle.com>
Subject: [PATCH 1/4] sparc64: use generic rwsem spinlocks rt
Date: Mon,  6 Jan 2014 09:25:07 +0530
Message-Id: <1388980510-10190-2-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388980510-10190-1-git-send-email-allen.pais@oracle.com>
References: <1388980510-10190-1-git-send-email-allen.pais@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the use of generic rwsem spinlocks
to support RT on sparc64

Acked-by: David S. Miller <davem@davemloft.net>
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

