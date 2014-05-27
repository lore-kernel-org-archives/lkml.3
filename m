Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaE0UJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:09:49 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50838 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaE0UJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:09:47 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com,
        linville@tuxdriver.com, burzalodowa@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, c@24.io
Subject: [PATCH 1/6] Staging: rtl8192u: r8180_93cx6.c & r8192U_wx.c fix checkpatch.pl errors and warnings
Date: Tue, 27 May 2014 13:09:45 -0700
Message-Id: <1401221390-10655-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following:

ERROR: do not use C99 // comments
ERROR: space required after that ',' (ctx:VxV)
ERROR: space required after that ';' (ctx:VxV)
ERROR: space required before the open brace '{'
ERROR: spaces required around that '=' (ctx:VxV)
ERROR: spaces required around that '<' (ctx:VxV)
ERROR: space required after that close brace '}'
ERROR: spaces required around that '==' (ctx:VxV)
ERROR: space required before the open parenthesis '('

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8180_93cx6.c |   58 ++++++++++++++++----------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index cd06054..a68068f 100644
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
@@ -96,50 +96,50 @@ static void eprom_send_bits_string(struct net_device *dev, short b[], int len)
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
-	//enable EPROM programming
+	ret = 0;
+	/* enable EPROM programming */
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
 	eprom_send_bits_string(dev, read_cmd, 3);
 	eprom_send_bits_string(dev, addr_str, addr_len);
 
-	//keep chip pin D to low state while reading.
-	//I'm unsure if it is necessary, but anyway shouldn't hurt
+	/* keep chip pin D to low state while reading.*/
+	/* I'm unsure if it is necessary, but anyway shouldn't hurt*/
 	eprom_w(dev, 0);
 
-	for(i=0;i<16;i++){
-		//eeprom needs a clk cycle between writing opcode&adr
-		//and reading data. (eeprom outs a dummy 0)
+	for (i = 0; i < 16; i++) {
+		/* eeprom needs a clk cycle between writing opcode&adr */
+		/* and reading data. (eeprom outs a dummy 0) */
 		eprom_ck_cycle(dev);
 		ret |= (eprom_r(dev)<<(15-i));
 	}
@@ -147,7 +147,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_cs(dev, 0);
 	eprom_ck_cycle(dev);
 
-	//disable EPROM programming
+	/* disable EPROM programming */
 	write_nic_byte_E(dev, EPROM_CMD,
 		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	return ret;
-- 
1.7.9.5

