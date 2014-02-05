Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaBEC2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 21:28:49 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63981 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBEC2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 21:28:46 -0500
Message-ID: <52F1A1DB.6090408@gmail.com>
Date: Tue, 04 Feb 2014 18:28:43 -0800
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        Rajat Jain <rajatxjain@gmail.com>
Subject: [PATCH v4 1/8] pciehp: Make check_link_active() non-static
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_link_active() functionality needs to be used by subsequent patches
(that introduce link state change based hotplug). Thus make the function
non-static, and rename it to pciehp_check_link_active() so as to be
consistent with other non-static functions.

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 drivers/pci/hotplug/pciehp.h     |    1 +
 drivers/pci/hotplug/pciehp_hpc.c |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 88b37ca..f952459 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -153,6 +153,7 @@ void pciehp_green_led_on(struct slot *slot);
 void pciehp_green_led_off(struct slot *slot);
 void pciehp_green_led_blink(struct slot *slot);
 int pciehp_check_link_status(struct controller *ctrl);
+bool pciehp_check_link_active(struct controller *ctrl);
 void pciehp_release_ctrl(struct controller *ctrl);
 int pciehp_reset_slot(struct slot *slot, int probe);
 
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 14acfcc..aed6ab4 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -206,7 +206,7 @@ static void pcie_write_cmd(struct controller *ctrl, u16 cmd, u16 mask)
 	mutex_unlock(&ctrl->ctrl_lock);
 }
 
-static bool check_link_active(struct controller *ctrl)
+bool pciehp_check_link_active(struct controller *ctrl)
 {
 	struct pci_dev *pdev = ctrl_dev(ctrl);
 	u16 lnk_status;
@@ -225,12 +225,12 @@ static void __pcie_wait_link_active(struct controller *ctrl, bool active)
 {
 	int timeout = 1000;
 
-	if (check_link_active(ctrl) == active)
+	if (pciehp_check_link_active(ctrl) == active)
 		return;
 	while (timeout > 0) {
 		msleep(10);
 		timeout -= 10;
-		if (check_link_active(ctrl) == active)
+		if (pciehp_check_link_active(ctrl) == active)
 			return;
 	}
 	ctrl_dbg(ctrl, "Data Link Layer Link Active not %s in 1000 msec\n",
-- 
1.7.9.5

