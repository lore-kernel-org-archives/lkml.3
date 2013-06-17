Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3FQPWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:22:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48121 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3FQPWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:22:07 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 09/11] media: davinci: vpif_display: use module_platform_driver()
Date: Mon, 17 Jun 2013 20:50:49 +0530
Message-Id: <1371482451-18314-10-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch uses module_platform_driver() to simplify the code.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/davinci/vpif_display.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 371af34..473d1a9 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1937,20 +1937,4 @@ static __refdata struct platform_driver vpif_driver = {
 	.remove	= vpif_remove,
 };
 
-static __init int vpif_init(void)
-{
-	return platform_driver_register(&vpif_driver);
-}
-
-/*
- * vpif_cleanup: This function un-registers device and driver to the kernel,
- * frees requested irq handler and de-allocates memory allocated for channel
- * objects.
- */
-static void vpif_cleanup(void)
-{
-	platform_driver_unregister(&vpif_driver);
-}
-
-module_init(vpif_init);
-module_exit(vpif_cleanup);
+module_platform_driver(vpif_driver);
-- 
1.7.9.5

