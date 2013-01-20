Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3ATKYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:24:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41419 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab3ATKYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:24:39 -0500
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/6] cpufreq: Make acpi-cpufreq link first
Date: Sun, 20 Jan 2013 11:24:27 +0100
Message-Id: <1358677470-17394-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358677470-17394-1-git-send-email-bp@alien8.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Now that the majority of x86 CPUs out there are supported by
acpi-cpufreq, we want it to load first and, in the AMD case, drop to
powernow-k8 only on K8s. If, however, both powernow-k8 and acpi-cpufreq
are built-in, the link order matters. Correct that.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index fadc4d496e2f..24d4a63fd6cf 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -19,11 +19,12 @@ obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= cpufreq-cpu0.o
 ##################################################################################
 # x86 drivers.
 # Link order matters. K8 is preferred to ACPI because of firmware bugs in early
-# K8 systems. ACPI is preferred to all other hardware-specific drivers.
+# K8 systems. This is still the case but acpi-cpufreq errors out so that
+# powernow-k8 can load then. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
-obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
 obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o mperf.o
+obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
 obj-$(CONFIG_X86_PCC_CPUFREQ)		+= pcc-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
 obj-$(CONFIG_X86_POWERNOW_K7)		+= powernow-k7.o
-- 
1.8.1.rc3

