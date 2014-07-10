Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaGJI1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:27:21 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:47544 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaGJISh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:18:37 -0400
From: Tom Gundersen <teg@jklm.no>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tom Gundersen <teg@jklm.no>, John Linville <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v7 17/33] net: airo - set name assign type
Date: Thu, 10 Jul 2014 10:17:22 +0200
Message-Id: <1404980258-30853-18-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404980258-30853-1-git-send-email-teg@jklm.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_netdev is first called without a name, before the name and name assign
type is open-coded later.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/airo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 8a93e78..2156b03 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2859,6 +2859,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	}
 
 	strcpy(dev->name, "eth%d");
+	dev->name_assign_type = NET_NAME_ENUM;
 	rc = register_netdev(dev);
 	if (rc) {
 		airo_print_err(dev->name, "Couldn't register_netdev");
-- 
1.9.3

