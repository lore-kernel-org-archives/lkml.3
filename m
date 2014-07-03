Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaGCTPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:15:03 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47240 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaGCTPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:15:00 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>, Alexandru Juncu <alexj@rosedu.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] video: fbdev: matrox: matroxfb_base.c:  Cleaning up a null pointer checks that could never happen
Date: Thu,  3 Jul 2014 21:16:13 +0200
Message-Id: <1404414974-9676-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of null pointer checks that could never happen

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/matrox/matroxfb_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
index 7116c53..cd9dc88 100644
--- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -1973,7 +1973,7 @@ static void matroxfb_register_device(struct matrox_fb_info* minfo) {
 	for (drv = matroxfb_driver_l(matroxfb_driver_list.next);
 	     drv != matroxfb_driver_l(&matroxfb_driver_list);
 	     drv = matroxfb_driver_l(drv->node.next)) {
-		if (drv && drv->probe) {
+		if (drv->probe) {
 			void *p = drv->probe(minfo);
 			if (p) {
 				minfo->drivers_data[i] = p;
-- 
1.7.10.4

