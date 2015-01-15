Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbbAOV7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:59:47 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57564 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753532AbbAOV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:59:42 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 04/17] ARM: at91: fix sam9n12 and sam9x5 arm_pm_idle
Date: Thu, 15 Jan 2015 22:58:07 +0100
Message-Id: <1421359100-8930-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sam9n12 and sam9x5 don't set arm_pm_idle because of an oversight, fix that.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-at91/at91sam9n12.c | 5 +++++
 arch/arm/mach-at91/at91sam9x5.c  | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
index b5ea69a3eaf6..276b8f0e4183 100644
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@ -15,6 +15,11 @@
 /* --------------------------------------------------------------------
  *  AT91SAM9N12 processor initialization
  * -------------------------------------------------------------------- */
+static void __init at91sam9n12_initialize(void)
+{
+	arm_pm_idle = at91sam9_idle;
+}
 
 AT91_SOC_START(at91sam9n12)
+	.init = at91sam9n12_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index 7b60a529db01..7b6fb1bca505 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -16,5 +16,11 @@
  *  AT91SAM9x5 processor initialization
  * -------------------------------------------------------------------- */
 
+static void __init at91sam9x5_initialize(void)
+{
+	arm_pm_idle = at91sam9_idle;
+}
+
 AT91_SOC_START(at91sam9x5)
+	.init = at91sam9x5_initialize,
 AT91_SOC_END
-- 
2.1.0

