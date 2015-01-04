Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbbADAIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 19:08:23 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62642 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbADAIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 19:08:21 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] mfd: omap-usb-host: Remove some unused functions
Date: Sun,  4 Jan 2015 01:11:21 +0100
Message-Id: <1420330281-5228-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
usbhs_readb() usbhs_writeb()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/mfd/omap-usb-host.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 83dab2f..6b0f305 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -129,16 +129,6 @@ static inline u32 usbhs_read(void __iomem *base, u32 reg)
 	return readl_relaxed(base + reg);
 }
 
-static inline void usbhs_writeb(void __iomem *base, u8 reg, u8 val)
-{
-	writeb_relaxed(val, base + reg);
-}
-
-static inline u8 usbhs_readb(void __iomem *base, u8 reg)
-{
-	return readb_relaxed(base + reg);
-}
-
 /*-------------------------------------------------------------------------*/
 
 /**
-- 
1.7.10.4

