Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaF0Dvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:51:45 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43581 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaF0Dvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:51:43 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>, rric@kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Charles.Garcia-Tobin@arm.com,
        lorenzo.pieralisi@arm.com, linaro-acpi@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 07/13] ARM64 / ACPI: Introduce lowlevel suspend function
Date: Fri, 27 Jun 2014 11:49:30 +0800
Message-Id: <1403840976-7456-8-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <graeme.gregory@linaro.org>

acpi_wakeup_address is used on x86 as the address bios jumps into
when machine wakes up from suspend. As arm64 does not have such a
bios this mechanism will be provided by other means. But the define
is still required inside the acpi core.

Introduce a null stub for acpi_suspend_lowlevel as this is also
required by core. This will be filled in when standards are
defined for arm64 ACPI global power states.

Reviewed-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h |   12 ++++++++++++
 drivers/acpi/plat/arm-core.c  |    7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 3ea6b84..a93e8ae 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -39,6 +39,18 @@ static inline void disable_acpi(void)
  */
 #define cpu_physical_id(cpu) -1
 
+/*
+ * Low-level suspend routine.
+ *
+ * ACPI S-states for ARM64 have to be defined
+ * and approved before doing anything else, maybe
+ * we need update the ACPI spec, here just we
+ * just introduce function and macro needed by
+ * ACPI core, and revisit them when the spec is ready.
+ */
+extern int (*acpi_suspend_lowlevel)(void);
+#define acpi_wakeup_address (0)
+
 static inline bool acpi_arch_is_smp(void)
 {
 	return 1;
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index cf46c25..0155a98 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -129,3 +129,10 @@ static int __init parse_acpi(char *arg)
 	return 0;
 }
 early_param("acpi", parse_acpi);
+
+/*
+ * acpi_suspend_lowlevel() - save kernel state and suspend.
+ *
+ * TBD when ARM/ARM64 starts to support suspend...
+ */
+int (*acpi_suspend_lowlevel)(void);
-- 
1.7.9.5

