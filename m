Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3LCQiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:38:50 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36445 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3LCQip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:38:45 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: [RFC part1 PATCH 6/7] ARM64 / ACPI: Introduce lowlevel suspend function
Date: Wed,  4 Dec 2013 00:36:50 +0800
Message-Id: <1386088611-2801-7-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lowlevel suspend function is needed for ACPI based suspend/resume,
introduce ARM related lowlevel function in this patch.

Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h |    4 ++++
 drivers/acpi/plat/arm-core.c  |    7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index e9444e4..c830adc 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -79,6 +79,10 @@ void arch_fix_phys_package_id(int num, u32 slot);
 /* temperally define -1 to make acpi core compilerable */
 #define cpu_physical_id(cpu) -1
 
+/* Low-level suspend routine. */
+extern int (*acpi_suspend_lowlevel)(void);
+#define acpi_wakeup_address (0)
+
 #else	/* !CONFIG_ACPI */
 #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
 #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index 7b8e64a..2b6df56 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -217,3 +217,10 @@ static int __init parse_acpi(char *arg)
 	return 0;
 }
 early_param("acpi", parse_acpi);
+
+/*
+ * acpi_suspend_lowlevel() - save kernel state and suspend.
+ *
+ * TBD when when ARM/ARM64 starts to support suspend...
+ */
+int (*acpi_suspend_lowlevel)(void);
-- 
1.7.9.5

