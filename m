Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3KSW6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:58:13 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62277 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3KSW6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:58:10 -0500
Message-ID: <528BECFF.7000900@gmail.com>
Date: Tue, 19 Nov 2013 14:58:07 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linux-PCI <linux-pci@vger.kernel.org>,
        Linux-hotplug <linux-hotplug@vger.kernel.org>,
        linux-kernel@vger.kernel.org
CC: Bjorn Helgaas <bhelgaas@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: [RFC PATCH 1/4] pciehp: Make check_link_active() non-static
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


check_link_active() functionality needs to be used by subsequent patches
(that introduce link state change based hotplug). Thus make the function
non-static, and rename it to pciehp_check_link_active() so as to be
consistent with other non-static functions.

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
---
 drivers/pci/hotplug/pciehp.h     |    1 +
 drivers/pci/hotplug/pciehp_hpc.c |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 541bbe6..fc322ed 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -154,6 +154,7 @@ void pciehp_green_led_on(struct slot *slot);
 void pciehp_green_led_off(struct slot *slot);
 void pciehp_green_led_blink(struct slot *slot);
 int pciehp_check_link_status(struct controller *ctrl);
+bool pciehp_check_link_active(struct controller *ctrl);
 void pciehp_release_ctrl(struct controller *ctrl);
 int pciehp_reset_slot(struct slot *slot, int probe);
 
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 51f56ef..3a5eee7 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -241,7 +241,7 @@ static int pcie_write_cmd(struct controller *ctrl, u16 cmd, u16 mask)
 	return retval;
 }
 
-static bool check_link_active(struct controller *ctrl)
+bool pciehp_check_link_active(struct controller *ctrl)
 {
 	bool ret = false;
 	u16 lnk_status;
@@ -261,12 +261,12 @@ static void __pcie_wait_link_active(struct controller *ctrl, bool active)
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

