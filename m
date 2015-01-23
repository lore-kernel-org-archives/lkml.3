Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbbAWW5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:57:49 -0500
Received: from mx1.scotdoyle.com ([23.226.141.211]:39342 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbbAWW5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:57:45 -0500
Date: Fri, 23 Jan 2015 22:55:29 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] fbcon: Remove unused vblank cursor code
Message-ID: <alpine.DEB.2.11.1501232247340.2377@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1fa0b29f3a43 ("fbdev: Kill Atari vblank cursor blinking")

rendered vbl_cursor_cnt and therefore CURSOR_DRAW_DELAY unused in fbcon.c,
so remove them.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
---
 drivers/video/console/fbcon.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index ea43724..b972106 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -146,9 +146,6 @@ static const struct consw fb_con;
 
 static int fbcon_set_origin(struct vc_data *);
 
-#define CURSOR_DRAW_DELAY		(1)
-
-static int vbl_cursor_cnt;
 static int fbcon_cursor_noblink;
 
 #define divides(a, b)	((!(a) || (b)%(a)) ? 0 : 1)
@@ -1329,7 +1326,6 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 
 	ops->cursor(vc, info, mode, y, get_color(vc, info, c, 1),
 		    get_color(vc, info, c, 0));
-	vbl_cursor_cnt = CURSOR_DRAW_DELAY;
 }
 
 static int scrollback_phys_max = 0;
-- 
2.1.4

