Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaJBHZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:25:21 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59309 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaJBHZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:25:20 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: rtsx: Fix build warnings for !PM
Date: Thu,  2 Oct 2014 09:25:17 +0200
Message-Id: <1412234717-4699-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

rtsx_pci_power_off() is called only from rtsx_pci_suspend(), which isn't
built when PM is disabled.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/mfd/rtsx_pcr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index f2643c221d34..30f7ca89a0e6 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -947,6 +947,7 @@ static void rtsx_pci_idle_work(struct work_struct *work)
 	mutex_unlock(&pcr->pcr_mutex);
 }
 
+#ifdef CONFIG_PM
 static void rtsx_pci_power_off(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	if (pcr->ops->turn_off_led)
@@ -961,6 +962,7 @@ static void rtsx_pci_power_off(struct rtsx_pcr *pcr, u8 pm_state)
 	if (pcr->ops->force_power_down)
 		pcr->ops->force_power_down(pcr, pm_state);
 }
+#endif
 
 static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 {
-- 
2.1.0

