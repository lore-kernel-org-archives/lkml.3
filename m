Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3GMLDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:03:09 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43982 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3GMLDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:03:07 -0400
From: Dragos Foianu <dragos.foianu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] aic7xxx/aic7770: replaced string duplication code with kstrdup
Date: Sat, 13 Jul 2013 14:03:00 +0100
Message-Id: <1373720580-13301-1-git-send-email-dragos.foianu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now using kstrdup instead of its implementation.

Found using coccinelle.

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
---
 drivers/scsi/aic7xxx/aic7770_osm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/aic7770_osm.c
index 0cb8ef6..3d401d0 100644
--- a/drivers/scsi/aic7xxx/aic7770_osm.c
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c
@@ -85,10 +85,9 @@ aic7770_probe(struct device *dev)
 	int	error;
 
 	sprintf(buf, "ahc_eisa:%d", eisaBase >> 12);
-	name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	name = kstrdup(buf, GFP_ATOMIC);
 	if (name == NULL)
 		return (ENOMEM);
-	strcpy(name, buf);
 	ahc = ahc_alloc(&aic7xxx_driver_template, name);
 	if (ahc == NULL)
 		return (ENOMEM);
-- 
1.7.10.4

