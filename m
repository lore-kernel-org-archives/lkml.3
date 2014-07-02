Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaGBVoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:44:39 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:50482 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaGBVoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:44:37 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>, Alexandru Juncu <alexj@rosedu.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: matrox: matroxfb_base.c:  Fix for possible null pointer dereference
Date: Wed,  2 Jul 2014 23:45:51 +0200
Message-Id: <1404337551-6499-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a possible null pointer dereference, there is otherwise a risk of a possible null pointer dereference

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/matrox/matroxfb_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
index 7116c53..85ef84b 100644
--- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -1971,9 +1971,9 @@ static void matroxfb_register_device(struct matrox_fb_info* minfo) {
 	int i = 0;
 	list_add(&minfo->next_fb, &matroxfb_list);
 	for (drv = matroxfb_driver_l(matroxfb_driver_list.next);
-	     drv != matroxfb_driver_l(&matroxfb_driver_list);
+	     drv && drv != matroxfb_driver_l(&matroxfb_driver_list);
 	     drv = matroxfb_driver_l(drv->node.next)) {
-		if (drv && drv->probe) {
+		if (drv->probe) {
 			void *p = drv->probe(minfo);
 			if (p) {
 				minfo->drivers_data[i] = p;
-- 
1.7.10.4

