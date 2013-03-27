Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3C0UMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:12:39 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:39012 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3C0UMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:12:38 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] drivers: video: matrox: changed kmalloc+memset with kzalloc
Date: Wed, 27 Mar 2013 22:12:19 +0200
Message-Id: <1364415139-22303-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/video/matrox/matroxfb_base.c |    3 +--
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
1.7.9.5

