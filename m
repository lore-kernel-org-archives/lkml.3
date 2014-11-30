Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaK3Lvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:51:52 -0500
Received: from mout.gmx.net ([212.227.15.19]:54503 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaK3Lvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:51:50 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: stephen@networkplumber.org
Cc: mlindner@marvell.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH] skge: Unmask interrupts in case of spurious interrupts
Date: Sun, 30 Nov 2014 12:51:31 +0100
Message-Id: <1417348291-1302-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:aq+FujE6G1HgbEMDi1eEPFbZF9nNOJKZwxe0rd0Zd00GASF1mh+
 pWkNSyUsowcT/+owFRICaLcP1D0tgEGyiV80k1pb501vQdVSUUfD+GRChfH0lOUesNM0G0D
 r+sUf94ZuP/sP1Kjew7A8MDMScK31pLiPw02QKFAfDm5newT716UrZa6/SPt2TTYpumMn/o
 Z3fO8o4+qm6lWl8pf70fw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of a spurious interrupt dont forget to reenable the interrupts that
have been masked by reading the interrupt source register.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 drivers/net/ethernet/marvell/skge.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 264eab7..7173836 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3433,10 +3433,9 @@ static irqreturn_t skge_intr(int irq, void *dev_id)
 
 	if (status & IS_HW_ERR)
 		skge_error_irq(hw);
-
+out:
 	skge_write32(hw, B0_IMSK, hw->intr_mask);
 	skge_read32(hw, B0_IMSK);
-out:
 	spin_unlock(&hw->hw_lock);
 
 	return IRQ_RETVAL(handled);
-- 
1.9.1

