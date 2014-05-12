Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaELBnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:07 -0400
Received: from 1wt.eu ([62.212.114.60]:34679 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbaELBnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:05 -0400
Message-Id: <20140512003204.166690989@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ying Xue <ying.xue@windriver.com>, "David S. Miller" <davem@davemloft.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 085/143] atm: idt77252: fix dev refcnt leak
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Xue <ying.xue@windriver.com>

[ Upstream commit b5de4a22f157ca345cdb3575207bf46402414bc1 ]

init_card() calls dev_get_by_name() to get a network deceive. But it
doesn't decrease network device reference count after the device is
used.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/atm/idt77252.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index e33ae00..adbaed5 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3557,6 +3557,7 @@ init_card(struct atm_dev *dev)
 	if (tmp) {
 		memcpy(card->atmdev->esi, tmp->dev_addr, 6);
 
+		dev_put(tmp);
 		printk("%s: ESI %02x:%02x:%02x:%02x:%02x:%02x\n",
 		       card->name, card->atmdev->esi[0], card->atmdev->esi[1],
 		       card->atmdev->esi[2], card->atmdev->esi[3],
-- 
1.7.12.2.21.g234cd45.dirty



