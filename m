Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaB0SZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:25:08 -0500
Received: from mout.gmx.net ([212.227.15.19]:64248 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaB0SZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:25:06 -0500
From: xypron.glpk@gmx.de
To: grant.likely@linaro.org
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Memory leak in scripts/dtc/util.c
Date: Thu, 27 Feb 2014 19:24:33 +0100
Message-Id: <1393525473-12238-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:UEqMVvzqztIp7aq4QumI3ufyYSg/oi8e25Wn4NaoAts7MouoWoV
 BypOlCRLG3jvJYUQGH1kDGs21bd8V/iGB3GroSU4shOLdoyoWt5ZJNpfKonzEaqGln+J7c/
 cqR7Ed/DlvXrerP/ZCbfJjIOyFF8lGRQT5x5VpNCG+QSrzn1yeu/60zHH3W7duVtx8eFZia
 jOYeZVs5PhSUW19ior3AQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

buf was leaked if out of memory

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 scripts/dtc/util.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/dtc/util.c b/scripts/dtc/util.c
index 2422c34..a1e2e59 100644
--- a/scripts/dtc/util.c
+++ b/scripts/dtc/util.c
@@ -210,9 +210,11 @@ int utilfdt_read_err(const char *filename, char **buffp)
 	do {
 		/* Expand the buffer to hold the next chunk */
 		if (offset == bufsize) {
+			char *buf_old = buf;
 			bufsize *= 2;
 			buf = realloc(buf, bufsize);
 			if (!buf) {
+				buf = buf_old;
 				ret = ENOMEM;
 				break;
 			}
-- 
1.7.10.4

