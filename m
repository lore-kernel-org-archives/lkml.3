Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaG2Jgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:36:55 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:33599 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaG2Jgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:36:53 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <gregkh@linuxfoundation.org>
CC: <andrea.merello@gmail.com>, <linville@tuxdriver.com>, <anarey@gmail.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>
Subject: [PATCH] staging:r8180: coding style: Fixed commenting style
Date: Tue, 29 Jul 2014 15:18:52 +0530
Message-ID: <1406627332-18195-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 29 Jul 2014 09:36:50.0462 (UTC) FILETIME=[9FB9E3E0:01CFAB10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8180_93cx6.c file that fixes
commenting style warning
---
 drivers/staging/rtl8192u/r8180_93cx6.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index fb8a7a8..97d9b3f 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -103,7 +103,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	u32 ret;
 
 	ret = 0;
-	//enable EPROM programming
+	/* enable EPROM programming */
 	write_nic_byte_E(dev, EPROM_CMD,
 		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	force_pci_posting(dev);
@@ -133,13 +133,16 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_send_bits_string(dev, read_cmd, 3);
 	eprom_send_bits_string(dev, addr_str, addr_len);
 
-	//keep chip pin D to low state while reading.
-	//I'm unsure if it is necessary, but anyway shouldn't hurt
+	/*
+	 * keep chip pin D to low state while reading.
+	 * I'm unsure if it is necessary, but anyway shouldn't hurt
+	 */
 	eprom_w(dev, 0);
 
 	for (i = 0; i < 16; i++) {
-		//eeprom needs a clk cycle between writing opcode&adr
-		//and reading data. (eeprom outs a dummy 0)
+		/* eeprom needs a clk cycle between writing opcode&adr
+		 * and reading data. (eeprom outs a dummy 0)
+		 */
 		eprom_ck_cycle(dev);
 		ret |= (eprom_r(dev)<<(15-i));
 	}
@@ -147,7 +150,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_cs(dev, 0);
 	eprom_ck_cycle(dev);
 
-	//disable EPROM programming
+	/* disable EPROM programming */
 	write_nic_byte_E(dev, EPROM_CMD,
 		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	return ret;
-- 
1.7.11.7

