Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaCBUjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 15:39:21 -0500
Received: from mout.gmx.net ([212.227.15.15]:51996 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaCBUjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 15:39:19 -0500
From: xypron.glpk@gmx.de
To: grant.likely@linaro.org, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, devicetree-compiler@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Consistently use xrealloc instead of realloc
Date: Sun,  2 Mar 2014 21:39:01 +0100
Message-Id: <1393792741-29043-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:D+jTB2hfAQIwo3hpJcvFi1miuToJRWLnMRkPDc1S6aEV7+JnYIH
 QMtnjQygrM4dMZl2hQTCIVAgHaOSmE5/+petBcqtUiXhsRf97KhwbtjNIWEfnexq66pKjQU
 nFqGIhHjNkQwIE8nMrgN1T2tVe+vlTTB+bkYwrq8YBwC63MGIdzlgYrTwpzQyTalBnO7uwK
 hME5ZxWLFRxcsLJKq2/6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

fdtput.c:
Replace the remaining call to realloc by xrealloc.
Some redundant lines in encode_value can be saved.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fdtput.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fdtput.c b/fdtput.c
index 5226a4e..2a8d674 100644
--- a/fdtput.c
+++ b/fdtput.c
@@ -96,12 +96,7 @@ static int encode_value(struct display_info *disp, char **arg, int arg_count,
 		/* enlarge our value buffer by a suitable margin if needed */
 		if (upto + len > value_size) {
 			value_size = (upto + len) + 500;
-			value = realloc(value, value_size);
-			if (!value) {
-				fprintf(stderr, "Out of mmory: cannot alloc "
-					"%d bytes\n", value_size);
-				return -1;
-			}
+			value = xrealloc(value, value_size);
 		}
 
 		ptr = value + upto;
-- 
1.7.10.4

