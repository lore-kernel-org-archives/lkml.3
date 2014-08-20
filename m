Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaHTLpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:45:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59015 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbaHTLoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 090/104] igbvf: add missing iounmap() on error in igbvf_probe()
Date: Wed, 20 Aug 2014 13:43:53 +0200
Message-Id: <e6b9c095868c710d5cd74aa638a55cf9ac5c07fc.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit de524681f88ff4ed293aa239f83c8cb04d59b47d upstream.

Add the missing iounmap() before return from igbvf_probe()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Tested-by: Sibai Li <Sibai.li@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 0c0b8f6855a2..04bf22e5ee31 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2692,7 +2692,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ei->get_variants) {
 		err = ei->get_variants(adapter);
 		if (err)
-			goto err_ioremap;
+			goto err_get_variants;
 	}
 
 	/* setup adapter struct */
@@ -2789,6 +2789,7 @@ err_hw_init:
 	kfree(adapter->rx_ring);
 err_sw_init:
 	igbvf_reset_interrupt_capability(adapter);
+err_get_variants:
 	iounmap(adapter->hw.hw_addr);
 err_ioremap:
 	free_netdev(netdev);
-- 
2.0.4

