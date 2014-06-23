Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaFWMIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:08:47 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:51102 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFWMIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:08:46 -0400
From: Vincent Heuken <me@vincentheuken.com>
To: liodot@gmail.com, charrer@alacritech.com, gregkh@linuxfoundation.org,
        matlackdavid@gmail.com, peter.p.waskiewicz.jr@intel.com,
        rashika.kheria@gmail.com, monamagarwal123@gmail.com, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Vincent Heuken <me@vincentheuken.com>
Subject: [PATCH] Staging: slicoss: fixed frivolous else statement  warnings in slicoss.c
Date: Mon, 23 Jun 2014 05:09:18 -0700
Message-Id: <1403525358-15747-1-git-send-email-me@vincentheuken.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for the slicoss.c file that fixes four instances
of the following warning:
WARNING: else is not generally useful after a break or return

Signed-off-by: Vincent Heuken <me@vincentheuken.com>
---
 drivers/staging/slicoss/slicoss.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 48841e7..50ece29 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -740,9 +740,9 @@ static bool slic_mac_filter(struct adapter *adapter,
 		if (opts & MAC_BCAST) {
 			adapter->rcv_broadcasts++;
 			return true;
-		} else {
-			return false;
 		}
+
+		return false;
 	}
 
 	if (is_multicast_ether_addr(ether_frame->ether_dhost)) {
@@ -763,10 +763,11 @@ static bool slic_mac_filter(struct adapter *adapter,
 				}
 				mcaddr = mcaddr->next;
 			}
-			return false;
-		} else {
+
 			return false;
 		}
+
+		return false;
 	}
 	if (opts & MAC_DIRECTED) {
 		adapter->rcv_unicasts++;
@@ -2714,9 +2715,10 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 			dev_err(&adapter->pcidev->dev,
 				"Failed to allocate DMA memory for EEPROM.\n");
 			return -ENOMEM;
-		} else {
-			memset(peeprom, 0, sizeof(struct slic_eeprom));
 		}
+
+		memset(peeprom, 0, sizeof(struct slic_eeprom));
+
 		slic_reg32_write(&slic_regs->slic_icr, ICR_INT_OFF, FLUSH);
 		mdelay(1);
 		pshmem = (struct slic_shmem *)(unsigned long)
@@ -2751,11 +2753,11 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 
 					slic_upr_request_complete(adapter, 0);
 					break;
-				} else {
-					adapter->pshmem->isr = 0;
-					slic_reg32_write(&slic_regs->slic_isr,
-							 0, FLUSH);
 				}
+
+				adapter->pshmem->isr = 0;
+				slic_reg32_write(&slic_regs->slic_isr,
+						 0, FLUSH);
 			} else {
 				mdelay(1);
 				i++;
-- 
2.0.0

