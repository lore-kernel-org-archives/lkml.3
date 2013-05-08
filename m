Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3EHSOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:14:03 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:50574 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab3EHSN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:13:59 -0400
Date: Thu, 9 May 2013 02:13:51 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] fbcon: delete unneeded function fbcon_takeover
Message-ID: <20130508181351.GC12344@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, alan@linux.intel.com,
	airlied@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no place use fbcon_takeover, and
fbcon_takeover has huge duplication code with
do_fbcon_takeover, we can achieve fbcon_takeover's
function with do_fbcon_takeover easily, so we
can just delete it.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/console/fbcon.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 1660644..47b9353 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -556,34 +556,6 @@ static int do_fbcon_takeover(int show_logo)
 	return err;
 }
 
-static int fbcon_takeover(int show_logo)
-{
-	int err, i;
-
-	if (!num_registered_fb)
-		return -ENODEV;
-
-	if (!show_logo)
-		logo_shown = FBCON_LOGO_DONTSHOW;
-
-	for (i = first_fb_vc; i <= last_fb_vc; i++)
-		con2fb_map[i] = info_idx;
-
-	err = take_over_console(&fb_con, first_fb_vc, last_fb_vc,
-				fbcon_is_default);
-
-	if (err) {
-		for (i = first_fb_vc; i <= last_fb_vc; i++) {
-			con2fb_map[i] = -1;
-		}
-		info_idx = -1;
-	} else {
-		fbcon_has_console_bind = 1;
-	}
-
-	return err;
-}
-
 #ifdef MODULE
 static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 			       int cols, int rows, int new_cols, int new_rows)
-- 
1.7.12.4.dirty
