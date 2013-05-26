Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3EZMCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 08:02:50 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50624 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3EZMCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 08:02:47 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 5/9] media: davinci: vpif_capture: use module_platform_driver()
Date: Sun, 26 May 2013 17:30:08 +0530
Message-Id: <1369569612-30915-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch uses module_platform_driver() to simplify the code.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   28 +------------------------
 1 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index f8b7304..38c1fba 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2338,30 +2338,4 @@ static __refdata struct platform_driver vpif_driver = {
 	.remove = vpif_remove,
 };
 
-/**
- * vpif_init: initialize the vpif driver
- *
- * This function registers device and driver to the kernel, requests irq
- * handler and allocates memory
- * for channel objects
- */
-static __init int vpif_init(void)
-{
-	return platform_driver_register(&vpif_driver);
-}
-
-/**
- * vpif_cleanup : This function clean up the vpif capture resources
- *
- * This will un-registers device and driver to the kernel, frees
- * requested irq handler and de-allocates memory allocated for channel
- * objects.
- */
-static void vpif_cleanup(void)
-{
-	platform_driver_unregister(&vpif_driver);
-}
-
-/* Function for module initialization and cleanup */
-module_init(vpif_init);
-module_exit(vpif_cleanup);
+module_platform_driver(vpif_driver);
-- 
1.7.0.4

