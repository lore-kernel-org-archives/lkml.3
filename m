Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab3IHDUD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56190 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756436Ab3IHDSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bing Zhao" <bzhao@marvell.com>,
        "=?UTF-8?q?Tomasz=20Mo=C5=84?=" <desowin@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.76704668@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [038/121] mwifiex: Add missing endian conversion.
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Moń <desowin@gmail.com>

commit 83e612f632c3897be29ef02e0472f6d63e258378 upstream.

Both type and pkt_len variables are in host endian and these should be in
Little Endian in the payload.

Signed-off-by: Tomasz Moń <desowin@gmail.com>
Acked-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1429,8 +1429,8 @@ static int mwifiex_sdio_host_to_card(str
 	/* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
 	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
-	*(u16 *) &payload[0] = (u16) pkt_len;
-	*(u16 *) &payload[2] = type;
+	*(__le16 *)&payload[0] = cpu_to_le16((u16)pkt_len);
+	*(__le16 *)&payload[2] = cpu_to_le16(type);
 
 	/*
 	 * This is SDIO specific header

