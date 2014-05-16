Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbaEPPZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:25:14 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:62115 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347AbaEPPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:25:12 -0400
Message-ID: <1400253910.20342.52.camel@x220>
Subject: [PATCH] ARM: remove check for CONFIG_CPU_ICACHE_STREAMING_DISABLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 16 May 2014 17:25:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2014 15:25:10.0619 (UTC) FILETIME=[069F42B0:01CF711B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_CPU_ICACHE_STREAMING_DISABLE was added in v2.6.4. But
the related Kconfig symbol was never added to the tree. So that check
has evaluated to false for a decade. Let's remove that check and the
single line it guards.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/mm/proc-arm925.S | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mm/proc-arm925.S b/arch/arm/mm/proc-arm925.S
index 97448c3acf38..3c31f32153ad 100644
--- a/arch/arm/mm/proc-arm925.S
+++ b/arch/arm/mm/proc-arm925.S
@@ -441,9 +441,6 @@ ENTRY(cpu_arm925_set_pte_ext)
 	.type	__arm925_setup, #function
 __arm925_setup:
 	mov	r0, #0
-#if defined(CONFIG_CPU_ICACHE_STREAMING_DISABLE)
-        orr     r0,r0,#1 << 7
-#endif
 
 	/* Transparent on, D-cache clean & flush mode. See  NOTE2 above */
         orr     r0,r0,#1 << 1			@ transparent mode on
-- 
1.9.0

