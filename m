Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaLDBuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:50:07 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:54485 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaLDBuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:50:05 -0500
From: Kevin Pietsch <kevinpietsch@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Kevin Pietsch <kevinpietsch@gmail.com>
Subject: [PATCH 1/1] Staging: ft1000: fix some coding style issues
Date: Wed,  3 Dec 2014 20:49:33 -0500
Message-Id: <1417657773-29027-1-git-send-email-kevinpietsch@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed braces from two single line if-else statements

Signed-off-by: Kevin Pietsch <kevinpietsch@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 44575c7..fadd47d 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -176,11 +176,10 @@ u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
 	spin_lock_irqsave(&info->dpram_lock, flags);
 	ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR, offset);
 	/* check if we want to read upper or lower 32-bit word */
-	if (Index) {
+	if (Index)
 		data = ft1000_read_reg(dev, FT1000_REG_MAG_DPDATAL);
-	} else {
+	else
 		data = ft1000_read_reg(dev, FT1000_REG_MAG_DPDATAH);
-	}
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 
 	return data;
@@ -208,11 +207,10 @@ static inline void ft1000_write_dpram_mag_16(struct net_device *dev,
 	/* Provide mutual exclusive access while reading ASIC registers. */
 	spin_lock_irqsave(&info->dpram_lock, flags);
 	ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR, offset);
-	if (Index) {
+	if (Index)
 		ft1000_write_reg(dev, FT1000_REG_MAG_DPDATAL, value);
-	} else {
+	else
 		ft1000_write_reg(dev, FT1000_REG_MAG_DPDATAH, value);
-	}
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 }
 
-- 
2.1.0

