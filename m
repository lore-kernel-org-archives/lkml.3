Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3K0AXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:23:18 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42478 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab3K0AXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:23:13 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Christian Daudt <bcm@fixthebug.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v2 2/6] ARM: do CPU-specific init for Broadcom Brahma15 cores
Date: Tue, 26 Nov 2013 16:22:24 -0800
Message-Id: <1385511748-27869-3-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform any CPU-specific initialization required on the
Broadcom Brahma-15 core.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/mm/proc-v7.S |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index bd17819..98ea423 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -193,6 +193,7 @@ __v7_cr7mp_setup:
 	b	1f
 __v7_ca7mp_setup:
 __v7_ca15mp_setup:
+__v7_b15mp_setup:
 	mov	r10, #0
 1:
 #ifdef CONFIG_SMP
@@ -494,6 +495,16 @@ __v7_ca15mp_proc_info:
 	.size	__v7_ca15mp_proc_info, . - __v7_ca15mp_proc_info
 
 	/*
+	 * Broadcom Corporation Brahma-B15 processor.
+	 */
+	.type	__v7_b15mp_proc_info, #object
+__v7_b15mp_proc_info:
+	.long	0x420f00f0
+	.long	0xff0ffff0
+	__v7_proc __v7_b15mp_setup, hwcaps = HWCAP_IDIV
+	.size	__v7_b15mp_proc_info, . - __v7_b15mp_proc_info
+
+	/*
 	 * Qualcomm Inc. Krait processors.
 	 */
 	.type	__krait_proc_info, #object
-- 
1.7.1

