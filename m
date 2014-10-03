Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbaJDAiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:38:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbaJCVmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Fu Zhonghui <zhonghui.fu@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 150/357] ACPI / LPSS: complete PM entries for LPSS power domain
Date: Fri,  3 Oct 2014 14:28:56 -0700
Message-Id: <20141003212937.980000231@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fu Zhonghui <zhonghui.fu@linux.intel.com>

commit f4168b617ac09986c4333accaff5d8ba5a9db7bf upstream.

PM entries of LPSS power domain were not implemented correctly
in commit c78b0830667a "ACPI / LPSS: custom power domain for LPSS".

This patch fixes and completes these PM entries.

Fixes: c78b0830667a (ACPI / LPSS: custom power domain for LPSS)
Signed-off-by: Li Aubrey <aubrey.li@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_lpss.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -583,7 +583,7 @@ static int acpi_lpss_suspend_late(struct
 	return acpi_dev_suspend_late(dev);
 }
 
-static int acpi_lpss_restore_early(struct device *dev)
+static int acpi_lpss_resume_early(struct device *dev)
 {
 	int ret = acpi_dev_resume_early(dev);
 
@@ -623,15 +623,15 @@ static int acpi_lpss_runtime_resume(stru
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


