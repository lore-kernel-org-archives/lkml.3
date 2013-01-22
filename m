Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3AVQmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:42:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43233 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab3AVQmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:42:43 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: bp@alien8.de
Cc: rjw@sisk.pl, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] Add module aliases for acpi-cpufreq
Date: Tue, 22 Jan 2013 11:42:24 -0500
Message-Id: <1358872944-7676-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi core will call request_module("acpi-cpufreq") on subsystem init,
but this will fail if the module isn't available at that stage of boot.
Add some module aliases to ensure that udev can load the module on Intel
and AMD systems with the appropriate feature bits - I /think/ that this
will also work on VIA systems, but haven't verified that.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/cpufreq/acpi-cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 0d048f6..7b0d49d 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -1030,4 +1030,11 @@ MODULE_PARM_DESC(acpi_pstate_strict,
 late_initcall(acpi_cpufreq_init);
 module_exit(acpi_cpufreq_exit);
 
+static const struct x86_cpu_id acpi_cpufreq_ids[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_ACPI),
+	X86_FEATURE_MATCH(X86_FEATURE_HW_PSTATE),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, acpi_cpufreq_ids);
+
 MODULE_ALIAS("acpi");
-- 
1.8.0.2

