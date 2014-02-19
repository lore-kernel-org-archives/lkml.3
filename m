Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbaBSFHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 00:07:53 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:43603 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaBSFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 00:07:50 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: libahci: make ahci_pmp_retry_softreset() as static
Date: Wed, 19 Feb 2014 14:07:39 +0900
Message-ID: <3035873.ZkIlzycZBr@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2a428e5e45bca3fc38fad17b9e2e14c5e6514ca0 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Wed, 19 Feb 2014 10:56:37 +0900
Subject: [PATCH] ata: libahci: make ahci_pmp_retry_softreset() as static

sparse says:

drivers/ata/libahci.c:1390:5: warning:
 symbol 'ahci_pmp_retry_softreset' was not declared. Should it be static?

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/ata/libahci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 36605ab..f9600fe 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1387,7 +1387,7 @@ static int ahci_bad_pmp_check_ready(struct ata_link *link)
 	return ata_check_ready(status);
 }
 
-int ahci_pmp_retry_softreset(struct ata_link *link, unsigned int *class,
+static int ahci_pmp_retry_softreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
-- 
1.7.9.5
---
