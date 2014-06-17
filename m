Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbaFQThs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:37:48 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:37611 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756338AbaFQThq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:37:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQJAPOXoFNbsl1t/2dsb2JhbABagw2rKgUBAQEBAQEFAZkmgQ4XdYQxLyOBAhg3iC4DFQHEew2GNheFY4ZwgiMdhC0EmEqBeY1YhgCBfoFEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/1] drivers/net/wireless/rt2x00/rt2x00dev.c: remove null test before kfree
Date: Tue, 17 Jun 2014 21:36:28 +0200
Message-Id: <1403033788-8315-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 2bde672..c2c2300 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1452,8 +1452,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Free the driver data.
 	 */
-	if (rt2x00dev->drv_data)
-		kfree(rt2x00dev->drv_data);
+	kfree(rt2x00dev->drv_data);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
 
-- 
1.8.4.5

