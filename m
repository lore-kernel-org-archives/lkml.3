Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab3LWFOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:14:11 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:43019 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3LWFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:14:07 -0500
Message-ID: <52B7C5AA.9070602@huawei.com>
Date: Mon, 23 Dec 2013 13:10:02 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Chas Williams <chas@cmf.nrl.navy.mil>,
        <linux-atm-general@lists.sourceforge.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/21] atm: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the recently added and possibly more efficient
ether_addr_equal_unaligned to instead of memcmp.

Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/atm/nicstar.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 5aca5f4..d636f7f 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -781,8 +781,7 @@ static int ns_init_card(int i, struct pci_dev *pcidev)
 	if (mac[i] == NULL || !mac_pton(mac[i], card->atmdev->esi)) {
 		nicstar_read_eprom(card->membase, NICSTAR_EPROM_MAC_ADDR_OFFSET,
 				   card->atmdev->esi, 6);
-		if (memcmp(card->atmdev->esi, "\x00\x00\x00\x00\x00\x00", 6) ==
-		    0) {
+		if (ether_addr_equal_unaligned(card->atmdev->esi, "\x00\x00\x00\x00\x00\x00")) {
 			nicstar_read_eprom(card->membase,
 					   NICSTAR_EPROM_MAC_ADDR_OFFSET_ALT,
 					   card->atmdev->esi, 6);
-- 
1.8.0


