Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473Ab3EGElN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:41:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759481Ab3EGEZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:42 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=WPtZURVTo4EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aanP3YNjZO4A:10 a=SaWEO8HGAAAA:8 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=w2ubnULX9RwA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035859.710154265@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Huang, Xiong" <xiong@qca.qualcomm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [112/126] atl1e: limit gso segment size to prevent generation of wrong ip
 length fields
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0112-atl1e-limit-gso-segment-size-to-prevent-generation-o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 31d1670e73f4911fe401273a8f576edc9c2b5fea ]

The limit of 0x3c00 is taken from the windows driver.

Suggested-by: Huang, Xiong <xiong@qca.qualcomm.com>
Cc: Huang, Xiong <xiong@qca.qualcomm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
index edfdf6b..b5fd934 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -186,7 +186,7 @@ struct atl1e_tpd_desc {
 /* how about 0x2000 */
 #define MAX_TX_BUF_LEN      0x2000
 #define MAX_TX_BUF_SHIFT    13
-/*#define MAX_TX_BUF_LEN  0x3000 */
+#define MAX_TSO_SEG_SIZE    0x3c00
 
 /* rrs word 1 bit 0:31 */
 #define RRS_RX_CSUM_MASK	0xFFFF
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index b986503..8f6b054 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2333,6 +2333,7 @@ static int __devinit atl1e_probe(struct pci_dev *pdev,
 
 	INIT_WORK(&adapter->reset_task, atl1e_reset_task);
 	INIT_WORK(&adapter->link_chg_task, atl1e_link_chg_task);
+	netif_set_gso_max_size(netdev, MAX_TSO_SEG_SIZE);
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_err(netdev, "register netdevice failed\n");
-- 
1.7.10.4


