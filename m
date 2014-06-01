Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbaFAL5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 07:57:41 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:40179 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005AbaFAL5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 07:57:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsQANUUi1NXQzKE/2dsb2JhbABYgwerUAQBAQEBAQEGmBuBCBd0gwIjgRo3iEYB1WwXhVWIGWQdhCoEmgCLG4gSgzo7gTA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/1 linux-next] drivers/tty/hvc/hvc_tile.c: use PTR_ERR_OR_ZERO
Date: Sun,  1 Jun 2014 13:56:23 +0200
Message-Id: <1401623783-3271-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

 drivers/tty/hvc/hvc_tile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_tile.c b/drivers/tty/hvc/hvc_tile.c
index 147d49e..df37486 100644
--- a/drivers/tty/hvc/hvc_tile.c
+++ b/drivers/tty/hvc/hvc_tile.c
@@ -196,7 +196,7 @@ static int __init hvc_tile_init(void)
 #ifndef __tilegx__
 	struct hvc_struct *hp;
 	hp = hvc_alloc(0, 0, &hvc_tile_get_put_ops, 128);
-	return IS_ERR(hp) ? PTR_ERR(hp) : 0;
+	return PTR_ERR_OR_ZERO(hp);
 #else
 	platform_device_register(&hvc_tile_pdev);
 	return platform_driver_register(&hvc_tile_driver);
-- 
1.8.4.5

