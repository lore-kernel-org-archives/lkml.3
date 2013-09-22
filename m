Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3IVSpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 14:45:19 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53836 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3IVSox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:44:53 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, archit@ti.com, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 3/5] OMAPDSS: DISPC: Fix assignment of 0/1 to bool variables
Date: Sun, 22 Sep 2013 20:44:11 +0200
Message-Id: <1379875453-20083-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
References: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 0 to false and 1 to true when assigning values to bool
variables. Inspired by commit 3db1cd5c05f35fb43eb134df6f321de4e63141f2.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@@
bool b;
@@
(
-b = 0
+b = false
|
-b = 1
+b = true
)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/video/omap2/dss/dispc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -u -p a/drivers/video/omap2/dss/dispc.c b/drivers/video/omap2/dss/dispc.c
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@ -2352,7 +2352,7 @@ int dispc_ovl_check(enum omap_plane plan
 {
 	enum omap_overlay_caps caps = dss_feat_get_overlay_caps(plane);
 	bool five_taps = true;
-	bool fieldmode = 0;
+	bool fieldmode = false;
 	u16 in_height = oi->height;
 	u16 in_width = oi->width;
 	bool ilace = timings->interlace;
@@ -2365,7 +2365,7 @@ int dispc_ovl_check(enum omap_plane plan
 	out_height = oi->out_height == 0 ? oi->height : oi->out_height;
 
 	if (ilace && oi->height == out_height)
-		fieldmode = 1;
+		fieldmode = true;
 
 	if (ilace) {
 		if (fieldmode)
@@ -2396,7 +2396,7 @@ static int dispc_ovl_setup_common(enum o
 		bool mem_to_mem)
 {
 	bool five_taps = true;
-	bool fieldmode = 0;
+	bool fieldmode = false;
 	int r, cconv = 0;
 	unsigned offset0, offset1;
 	s32 row_inc;
@@ -2417,7 +2417,7 @@ static int dispc_ovl_setup_common(enum o
 	out_height = out_height == 0 ? height : out_height;
 
 	if (ilace && height == out_height)
-		fieldmode = 1;
+		fieldmode = true;
 
 	if (ilace) {
 		if (fieldmode)

