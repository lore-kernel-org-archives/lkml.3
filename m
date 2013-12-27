Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3L0CkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 21:40:24 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36015 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3L0CkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 21:40:22 -0500
Date: Fri, 27 Dec 2013 10:39:18 +0800
From: Wang YanQing <udknight@gmail.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, airlied@redhat.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, kamal@whence.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fbcon: trivial optimization for fbcon_exit
Message-ID: <20131227023917.GA3908@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, tomi.valkeinen@ti.com,
	plagnioj@jcrosoft.com, airlied@redhat.com,
	gregkh@linuxfoundation.org, akpm@linux-foundation.org,
	kamal@whence.com, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break out as soon as we find a mapped entry con2fb_map.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/console/fbcon.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index cd8a802..f39931f 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3547,8 +3547,10 @@ static void fbcon_exit(void)
 			"no"));
 
 		for (j = first_fb_vc; j <= last_fb_vc; j++) {
-			if (con2fb_map[j] == i)
+			if (con2fb_map[j] == i) {
 				mapped = 1;
+				break;
+			}
 		}
 
 		if (mapped) {
-- 
1.8.3.4.8.g69490f3.dirty
