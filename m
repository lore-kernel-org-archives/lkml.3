Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaE0Wf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:35:56 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57559 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaE0Wfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:35:54 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH] Staging: rtl8192u: r8180_93cx6.c Added missing spaces
Date: Tue, 27 May 2014 15:35:09 -0700
Message-Id: <1401230109-3603-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added spaces needed in the proper places to address:

ERROR: space required after that ',' (ctx:VxV)
ERROR: space required after that ';' (ctx:VxV)
ERROR: space required after that close brace '}'
ERROR: space required before the open brace '{'
ERROR: space required before the open parenthesis '('
ERROR: spaces required around that '<' (ctx:VxV)
ERROR: spaces required around that '=' (ctx:VxV)
ERROR: spaces required around that '==' (ctx:VxV)

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8180_93cx6.c | 46 +++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index cd06054..fb8a7a8 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -53,7 +53,7 @@ static void eprom_ck_cycle(struct net_device *dev)
 }
 
 
-static void eprom_w(struct net_device *dev,short bit)
+static void eprom_w(struct net_device *dev, short bit)
 {
 	u8 cmdreg;
 
@@ -86,7 +86,7 @@ static void eprom_send_bits_string(struct net_device *dev, short b[], int len)
 {
 	int i;
 
-	for(i=0; i<len; i++){
+	for (i = 0; i < len; i++) {
 		eprom_w(dev, b[i]);
 		eprom_ck_cycle(dev);
 	}
@@ -96,37 +96,37 @@ static void eprom_send_bits_string(struct net_device *dev, short b[], int len)
 u32 eprom_read(struct net_device *dev, u32 addr)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	short read_cmd[]={1,1,0};
+	short read_cmd[] = {1, 1, 0};
 	short addr_str[8];
 	int i;
 	int addr_len;
 	u32 ret;
 
-	ret=0;
+	ret = 0;
 	//enable EPROM programming
 	write_nic_byte_E(dev, EPROM_CMD,
 		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 
-	if (priv->epromtype==EPROM_93c56){
-		addr_str[7]=addr & 1;
-		addr_str[6]=addr & (1<<1);
-		addr_str[5]=addr & (1<<2);
-		addr_str[4]=addr & (1<<3);
-		addr_str[3]=addr & (1<<4);
-		addr_str[2]=addr & (1<<5);
-		addr_str[1]=addr & (1<<6);
-		addr_str[0]=addr & (1<<7);
-		addr_len=8;
-	}else{
-		addr_str[5]=addr & 1;
-		addr_str[4]=addr & (1<<1);
-		addr_str[3]=addr & (1<<2);
-		addr_str[2]=addr & (1<<3);
-		addr_str[1]=addr & (1<<4);
-		addr_str[0]=addr & (1<<5);
-		addr_len=6;
+	if (priv->epromtype == EPROM_93c56) {
+		addr_str[7] = addr & 1;
+		addr_str[6] = addr & (1<<1);
+		addr_str[5] = addr & (1<<2);
+		addr_str[4] = addr & (1<<3);
+		addr_str[3] = addr & (1<<4);
+		addr_str[2] = addr & (1<<5);
+		addr_str[1] = addr & (1<<6);
+		addr_str[0] = addr & (1<<7);
+		addr_len = 8;
+	} else {
+		addr_str[5] = addr & 1;
+		addr_str[4] = addr & (1<<1);
+		addr_str[3] = addr & (1<<2);
+		addr_str[2] = addr & (1<<3);
+		addr_str[1] = addr & (1<<4);
+		addr_str[0] = addr & (1<<5);
+		addr_len = 6;
 	}
 	eprom_cs(dev, 1);
 	eprom_ck_cycle(dev);
@@ -137,7 +137,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	//I'm unsure if it is necessary, but anyway shouldn't hurt
 	eprom_w(dev, 0);
 
-	for(i=0;i<16;i++){
+	for (i = 0; i < 16; i++) {
 		//eeprom needs a clk cycle between writing opcode&adr
 		//and reading data. (eeprom outs a dummy 0)
 		eprom_ck_cycle(dev);
-- 
1.9.1

