Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaLCLo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:44:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbaLCL1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 075/101] Input: wm97xx - adapt parameters to tosa touchscreen.
Date: Wed,  3 Dec 2014 12:26:37 +0100
Message-Id: <05b598ab439ca2aaff4930d45ec74062f484d52e.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 859abd1d59e2db07d2e4db27074fc33568353d11 upstream.

Sharp SL-6000 (tosa) touchscreen needs wider limits to properly map all
points on the screen. Expand ranges in abs_x and abs_y arrays according
to the touchscreen area.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/touchscreen/wm97xx-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index 7e45c9f6e6b7..b08c16bd816e 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -70,11 +70,11 @@
  * Documentation/input/input-programming.txt for more details.
  */
 
-static int abs_x[3] = {350, 3900, 5};
+static int abs_x[3] = {150, 4000, 5};
 module_param_array(abs_x, int, NULL, 0);
 MODULE_PARM_DESC(abs_x, "Touchscreen absolute X min, max, fuzz");
 
-static int abs_y[3] = {320, 3750, 40};
+static int abs_y[3] = {200, 4000, 40};
 module_param_array(abs_y, int, NULL, 0);
 MODULE_PARM_DESC(abs_y, "Touchscreen absolute Y min, max, fuzz");
 
-- 
2.1.3

