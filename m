Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaA0WaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:30:20 -0500
Received: from mout.gmx.net ([212.227.17.21]:54598 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbaA0WaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:30:17 -0500
From: xypron.glpk@gmx.de
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, ke42caxa@cip.cs.fau.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] usbip/userspace/libsrc/names.c: memory leak
Date: Mon, 27 Jan 2014 23:29:48 +0100
Message-Id: <1390861789-8981-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:sfebyW4+BjLT1jOxuOFTKTQRJ+pdfs+oygpyZpkUSP8mZXO3m9d
 s0Kiw8WW2caRAtjKcy1/HX/N6oS9Mhdg73QszPCNb5gsSnvPH6EwUvAD0WKl932JiA9mJaw
 T7J5kDbAfRxdm2gWymsprI9amzSViLI42FW7cRxTnYz4DJzGEctoiEASTitNVIs6ZGH0K6I
 4aqJGfpq4Ye8xkbu1EgUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

p is freed if NULL.
p is leaked if second calloc fails.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/staging/usbip/userspace/libsrc/names.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/names.c b/drivers/staging/usbip/userspace/libsrc/names.c
index 3c8d28b..b2904e8 100644
--- a/drivers/staging/usbip/userspace/libsrc/names.c
+++ b/drivers/staging/usbip/userspace/libsrc/names.c
@@ -170,12 +170,12 @@ static void *my_malloc(size_t size)
 
 	p = calloc(1, sizeof(struct pool));
 	if (!p) {
-		free(p);
 		return NULL;
 	}
 
 	p->mem = calloc(1, size);
 	if (!p->mem)
+		free(p);
 		return NULL;
 
 	p->next = pool_head;
-- 
1.7.10.4

