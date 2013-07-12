Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056Ab3GLOAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:00:50 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:49733 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964886Ab3GLOAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:00:47 -0400
From: Alexandru Juncu <alexj@rosedu.org>
To: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com, alexj@rosedu.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] matroxfb: replace kmalloc and memset with kzalloc.
Date: Fri, 12 Jul 2013 17:00:18 +0300
Message-Id: <1373637618-10529-1-git-send-email-alexj@rosedu.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
---
 drivers/video/matrox/matroxfb_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index 401a56e..2456529 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -2029,10 +2029,9 @@ static int matroxfb_probe(struct pci_dev* pdev, const struct pci_device_id* dumm
 		return -1;
 	}
 
-	minfo = kmalloc(sizeof(*minfo), GFP_KERNEL);
+	minfo = kzalloc(sizeof(*minfo), GFP_KERNEL);
 	if (!minfo)
 		return -1;
-	memset(minfo, 0, sizeof(*minfo));
 
 	minfo->pcidev = pdev;
 	minfo->dead = 0;
-- 
1.8.1.2

