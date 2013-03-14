Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab3CNKml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:42:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52075 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab3CNKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bruce Allan <bruce.w.allan@intel.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 75/88] e1000e: fix pci-device enable-counter balance
Date: Thu, 14 Mar 2013 10:36:08 +0000
Message-Id: <1363257381-15900-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit 4e0855dff094b0d56d6b5b271e0ce7851cc1e063 upstream.

This patch removes redundant and unbalanced pci_disable_device() from
__e1000_shutdown(). pci_clear_master() is enough, device can go into
suspended state with elevated enable_cnt.

Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35

Cc: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Borislav Petkov <bp@suse.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 2c78ef0..2ea52ce 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5560,7 +5560,7 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	 */
 	e1000e_release_hw_control(adapter);
 
-	pci_disable_device(pdev);
+	pci_clear_master(pdev);
 
 	return 0;
 }
-- 
1.8.1.2

