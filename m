Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaIIFeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:34:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:8179 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbaIIFeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:34:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208,223";a="383347446"
Message-ID: <540E9145.50403@linux.intel.com>
Date: Tue, 09 Sep 2014 13:33:57 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / LPSS: complete PM entries for LPSS power domain
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From de3dfa34bd7f219586057a1e0679f9e7515fa722 Mon Sep 17 00:00:00 2001
From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
Date: Tue, 9 Sep 2014 10:54:30 +0800
Subject: [PATCH] ACPI / LPSS: complete PM entries for LPSS power domain

PM entries of LPSS power domain were not implemented correctly
in the patch "ACPI / LPSS: custom power domain for LPSS"
commit ID c78b0830667a7e7c1f0ca65b76b33166a84806b3.
This patch fixes and completes these PM entries.

Signed-off-by: Li Aubrey <aubrey.li@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 9dfec48..fddc1e8 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -610,7 +610,7 @@ static int acpi_lpss_suspend_late(struct device *dev)
 	return acpi_dev_suspend_late(dev);
 }
 
-static int acpi_lpss_restore_early(struct device *dev)
+static int acpi_lpss_resume_early(struct device *dev)
 {
 	int ret = acpi_dev_resume_early(dev);
 
@@ -650,15 +650,15 @@ static int acpi_lpss_runtime_resume(struct device *dev)
 static struct dev_pm_domain acpi_lpss_pm_domain = {
 	.ops = {
 #ifdef CONFIG_PM_SLEEP
-		.suspend_late = acpi_lpss_suspend_late,
-		.restore_early = acpi_lpss_restore_early,
 		.prepare = acpi_subsys_prepare,
 		.complete = acpi_subsys_complete,
 		.suspend = acpi_subsys_suspend,
-		.resume_early = acpi_subsys_resume_early,
+		.suspend_late = acpi_lpss_suspend_late,
+		.resume_early = acpi_lpss_resume_early,
 		.freeze = acpi_subsys_freeze,
 		.poweroff = acpi_subsys_suspend,
-		.poweroff_late = acpi_subsys_suspend_late,
+		.poweroff_late = acpi_lpss_suspend_late,
+		.restore_early = acpi_lpss_resume_early,
 #endif
 #ifdef CONFIG_PM_RUNTIME
 		.runtime_suspend = acpi_lpss_runtime_suspend,
-- 1.7.1

