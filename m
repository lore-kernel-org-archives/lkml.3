Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaBSGS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:18:56 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52338 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaBSGSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:18:54 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: [PATCH] ata: libahci: replace obselete simple_strtoul() with kstrtouint()
Date: Wed, 19 Feb 2014 15:18:49 +0900
Message-ID: <10174432.hzSAsi5PnJ@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a6ff4eec0b80ff6596a278623a02e3ed462c49ed Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Wed, 19 Feb 2014 13:44:24 +0900
Subject: [PATCH] ata: libahci: replace obselete simple_strtoul() with
 kstrtouint()

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/ata/libahci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 36605ab..417946b 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1032,12 +1032,13 @@ static ssize_t ahci_led_show(struct ata_port *ap, char *buf)
 static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 				size_t size)
 {
-	int state;
+	unsigned int state;
 	int pmp;
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ahci_em_priv *emp;
 
-	state = simple_strtoul(buf, NULL, 0);
+	if (kstrtouint(buf, 0, &state) < 0)
+		return -EINVAL;
 
 	/* get the slot number from the message */
 	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
-- 
1.7.9.5
---

