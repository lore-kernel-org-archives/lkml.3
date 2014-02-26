Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaBZK3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:29:52 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40311 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaBZK3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:29:48 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH v7 4/9] ARM: do CPU-specific init for Broadcom Brahma15 cores
Date: Wed, 26 Feb 2014 02:29:07 -0800
Message-Id: <1393410552-21497-5-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1393410552-21497-1-git-send-email-marc.ceeeee@gmail.com>
References: <1393410552-21497-1-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform any CPU-specific initialization required on the
Broadcom Brahma-15 core.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mm/proc-v7.S |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 74f6033..e3da338 100644
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

