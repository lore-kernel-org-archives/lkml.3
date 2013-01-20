Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3ATKYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:24:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41415 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3ATKYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:24:39 -0500
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/6] powernow-k8: Add a kconfig dependency on acpi-cpufreq
Date: Sun, 20 Jan 2013 11:24:25 +0100
Message-Id: <1358677470-17394-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358677470-17394-1-git-send-email-bp@alien8.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Andreas reports in https://bugzilla.kernel.org/show_bug.cgi?id=51741
that with his Gentoo config, acpi-cpufreq wasn't enabled and powernow-k8
couldn't handoff properly to acpi-cpufreq leading to running without
P-state support (i.e., cores are constantly in P0).

To alleaviate that, we need to make powernow-k8 depend on acpi-cpufreq
so that acpi-cpufreq is always present.

Reported-by: Andreas <linuxuser330250@gmx.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/Kconfig.x86 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 934854ae5eb4..7227cd734042 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -106,7 +106,7 @@ config X86_POWERNOW_K7_ACPI
 config X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
 	select CPU_FREQ_TABLE
-	depends on ACPI && ACPI_PROCESSOR
+	depends on ACPI && ACPI_PROCESSOR && X86_ACPI_CPUFREQ
 	help
 	  This adds the CPUFreq driver for K8/early Opteron/Athlon64 processors.
 	  Support for K10 and newer processors is now in acpi-cpufreq.
-- 
1.8.1.rc3

