Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbaDIHnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:43:14 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.95]:39091 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaDIHnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:43:13 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: perex@perex.cz, tiwai@suse.de, mano@roarinelk.homelinux.net
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] ALSA: au1x00: use module_platform_driver()
Date: Wed,  9 Apr 2014 09:42:32 +0200
Message-Id: <1397029352-30889-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate boilerplate code by using module_platform_driver().

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 sound/mips/au1x00.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/sound/mips/au1x00.c b/sound/mips/au1x00.c
index a7cc49e..d10ef76 100644
--- a/sound/mips/au1x00.c
+++ b/sound/mips/au1x00.c
@@ -725,15 +725,4 @@ struct platform_driver au1000_ac97c_driver = {
 	.remove		= au1000_ac97_remove,
 };
 
-static int __init au1000_ac97_load(void)
-{
-	return platform_driver_register(&au1000_ac97c_driver);
-}
-
-static void __exit au1000_ac97_unload(void)
-{
-	platform_driver_unregister(&au1000_ac97c_driver);
-}
-
-module_init(au1000_ac97_load);
-module_exit(au1000_ac97_unload);
+module_platform_driver(au1000_ac97c_driver);
-- 
1.9.0

