Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbaD2Rgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:36:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbaD2Rgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:36:31 -0400
From: Jan Moskyto Matejka <mq@suse.cz>
To: Alexey Charkov <alchark@gmail.com>, Roger Luethi <rl@hellgate.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Moskyto Matejka <mq@suse.cz>
Subject: [PATCH] net: via-rhine: fix compiler warning
Date: Tue, 29 Apr 2014 19:36:11 +0200
Message-Id: <1398792971-10379-1-git-send-email-mq@suse.cz>
X-Mailer: git-send-email 1.8.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed different size cast warning:

	drivers/net/ethernet/via/via-rhine.c: In function ‘rhine_init_one_platform’:
	drivers/net/ethernet/via/via-rhine.c:1132:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
	  revision = (u32)match->data;
		     ^

That code was added in commit 2d283862dc62daead9db0dc89cd0d0351e91f765
("net: via-rhine: add OF bus binding").

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
---
 drivers/net/ethernet/via/via-rhine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 4fa9201..76d18e0 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -288,7 +288,7 @@ MODULE_DEVICE_TABLE(pci, rhine_pci_tbl);
  * (for quirks etc.)
  */
 static struct of_device_id rhine_of_tbl[] = {
-	{ .compatible = "via,vt8500-rhine", .data = (void *)0x84 },
+	{ .compatible = "via,vt8500-rhine", .data = (u32 []) { 0x84 } },
 	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(of, rhine_of_tbl);
@@ -1129,7 +1129,7 @@ static int rhine_init_one_platform(struct platform_device *pdev)
 	if (!irq)
 		return -EINVAL;
 
-	revision = (u32)match->data;
+	revision = *((u32 *) match->data);
 	if (!revision)
 		return -EINVAL;
 
-- 
1.8.4.5

