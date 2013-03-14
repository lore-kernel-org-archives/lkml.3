Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961Ab3CNRM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:12:26 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:52503 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964840Ab3CNRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:09:45 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Josh Wu <josh.wu@atmel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2 1/8] drivers: media: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 18:09:31 +0100
Message-Id: <1363280978-24051-2-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers to use the
module_platform_driver_probe() macro which makes the code smaller and
a bit simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/platform/soc_camera/atmel-isi.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 82dbf99..12ba31d 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -1081,17 +1081,7 @@ static struct platform_driver atmel_isi_driver = {
 	},
 };
 
-static int __init atmel_isi_init_module(void)
-{
-	return  platform_driver_probe(&atmel_isi_driver, &atmel_isi_probe);
-}
-
-static void __exit atmel_isi_exit(void)
-{
-	platform_driver_unregister(&atmel_isi_driver);
-}
-module_init(atmel_isi_init_module);
-module_exit(atmel_isi_exit);
+module_platform_driver_probe(atmel_isi_driver, atmel_isi_probe);
 
 MODULE_AUTHOR("Josh Wu <josh.wu@atmel.com>");
 MODULE_DESCRIPTION("The V4L2 driver for Atmel Linux");
-- 
1.8.1.5

