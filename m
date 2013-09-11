Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3IKFeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:34:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3IKE5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:19 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Lsr6glGAUncA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=q7KCNmc4lIsA:10 a=pGLkceISAAAA:8 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=9RRF0ttvEvMA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042916.322818054@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [144/251] mwifiex: Add missing endian conversion.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0144-mwifiex-Add-missing-endian-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>

[ Upstream commit 83e612f632c3897be29ef02e0472f6d63e258378 ]

Both type and pkt_len variables are in host endian and these should be in
Little Endian in the payload.

Signed-off-by: Tomasz Moń <desowin@gmail.com>
Acked-by: Bing Zhao <bzhao@marvell.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/mwifiex/sdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 82cf0fa..821d9d2 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1455,8 +1455,8 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	/* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
 	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
-	*(u16 *) &payload[0] = (u16) pkt_len;
-	*(u16 *) &payload[2] = type;
+	*(__le16 *)&payload[0] = cpu_to_le16((u16)pkt_len);
+	*(__le16 *)&payload[2] = cpu_to_le16(type);
 
 	/*
 	 * This is SDIO specific header
-- 
1.7.10.4


