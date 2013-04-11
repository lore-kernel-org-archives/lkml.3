Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937734Ab3DKAIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:08:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937696Ab3DKAHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:07:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 21/30] ASoC: samsung/i2s: fix module_device_table
Date: Thu, 11 Apr 2013 02:05:03 +0200
Message-Id: <1365638712-1028578-22-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ypAGLWtTFysJEFUTsFgVeFiVRMsb71LKKratEO/N5hi
 F3iJln7CyZBZjKatuQFJHSYVhOjTYlKuVdY+jYJ9NHJI0ZApRG
 E6ZzQTuXpTZ44Qnk4UsTA5gyEIj3BfuS7lD0SJGLQUylky/PAx
 rOYRMD9ev6qwp586PXj8Ct6mqT/m2eUGb9z3gig+jpkasQzqO8
 8zTCbWJn4SIEpUTliwYpUZUBoTEuSYdBv+H14DCSSNyCjE6sLY
 14VwWi1ouOWFt7bZeToa19U4fJ9GrTCUbvFArN6aQh0oW6JIC7
 lTG0YFJcRUMICKAGAkz1wDdx8dONgHI4FU3Do1crl+6pX6ePnw
 OQGcCLi2vtIWwOMvn6wv5AC2V1iKQF/rgyE16zeVItrMWpGqqE
 Ccn81I4JzsGXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second argument to the module_device_table macro must be the
name of the device id array. In the samsung i2s driver, there
was a small typo, resulting in a build error when building it
as a loadable module.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 sound/soc/samsung/i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 61f2622..f7c6816 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -1289,7 +1289,7 @@ static struct platform_device_id samsung_i2s_driver_ids[] = {
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(platform, samsung-i2s-driver-ids);
+MODULE_DEVICE_TABLE(platform, samsung_i2s_driver_ids);
 
 #ifdef CONFIG_OF
 static struct samsung_i2s_dai_data samsung_i2s_dai_data_array[] = {
-- 
1.8.1.2

