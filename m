Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967695Ab3HIB7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967461Ab3HIB7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 057/102] mwifiex: Add missing endian conversion.
Date: Thu,  8 Aug 2013 18:57:33 -0700
Message-Id: <20130809015023.531116421@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Moń <desowin@gmail.com>

commit 83e612f632c3897be29ef02e0472f6d63e258378 upstream.

Both type and pkt_len variables are in host endian and these should be in
Little Endian in the payload.

Signed-off-by: Tomasz Moń <desowin@gmail.com>
Acked-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/sdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1441,8 +1441,8 @@ static int mwifiex_sdio_host_to_card(str
 	/* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
 	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
-	*(u16 *) &payload[0] = (u16) pkt_len;
-	*(u16 *) &payload[2] = type;
+	*(__le16 *)&payload[0] = cpu_to_le16((u16)pkt_len);
+	*(__le16 *)&payload[2] = cpu_to_le16(type);
 
 	/*
 	 * This is SDIO specific header


