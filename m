Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaLOO2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:28:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaLOO21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Rustad <mark.d.rustad@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 099/168] ixgbe: Fix possible null-dereference in error path
Date: Mon, 15 Dec 2014 14:25:53 +0000
Message-Id: <1418653622-21105-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit 508a8c9e264e1057f663e578c47c5ffa00adb160 upstream.

In ixgbe_probe, the code at label err_dma can dereference adapter
when it has a NULL value. The check is there to avoid disabling a
disabled device. When adapter is NULL, treat it as if the device
is enabled, because it is enabled in that case.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 889005922c33..c4d560d7dabb 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8477,7 +8477,7 @@ err_alloc_etherdev:
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 err_pci_reg:
 err_dma:
-	if (!test_and_set_bit(__IXGBE_DISABLED, &adapter->state))
+	if (!adapter || !test_and_set_bit(__IXGBE_DISABLED, &adapter->state))
 		pci_disable_device(pdev);
 	return err;
 }
-- 
2.1.3

