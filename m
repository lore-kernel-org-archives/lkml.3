Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422956Ab3LFXUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:20:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48907 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422940Ab3LFXT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:19:59 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 093/152] mwifiex: correct packet length for packets from SDIO interface
Date: Fri,  6 Dec 2013 15:10:17 -0800
Message-Id: <1386371476-2477-94-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit d03b4aa77e1187b77dfe37d14a923547f00baa66 upstream.

While receiving a packet on SDIO interface, we allocate skb with
size multiple of SDIO block size. We need to resize this skb
after RX using packet length from RX header.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 86c025d..2df55d8 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -944,7 +944,10 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 				    struct sk_buff *skb, u32 upld_typ)
 {
 	u8 *cmd_buf;
+	__le16 *curr_ptr = (__le16 *)skb->data;
+	u16 pkt_len = le16_to_cpu(*curr_ptr);
 
+	skb_trim(skb, pkt_len);
 	skb_pull(skb, INTF_HEADER_LEN);
 
 	switch (upld_typ) {
-- 
1.8.3.2

