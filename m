Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3LBUDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:03:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3LBTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 103/212] mwifiex: correct packet length for packets from SDIO interface
Date: Mon,  2 Dec 2013 11:14:54 -0800
Message-Id: <20131202191258.831726426@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit d03b4aa77e1187b77dfe37d14a923547f00baa66 upstream.

While receiving a packet on SDIO interface, we allocate skb with
size multiple of SDIO block size. We need to resize this skb
after RX using packet length from RX header.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/sdio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1029,7 +1029,10 @@ static int mwifiex_decode_rx_packet(stru
 				    struct sk_buff *skb, u32 upld_typ)
 {
 	u8 *cmd_buf;
+	__le16 *curr_ptr = (__le16 *)skb->data;
+	u16 pkt_len = le16_to_cpu(*curr_ptr);
 
+	skb_trim(skb, pkt_len);
 	skb_pull(skb, INTF_HEADER_LEN);
 
 	switch (upld_typ) {


