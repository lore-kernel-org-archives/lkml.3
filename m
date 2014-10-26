Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaJZMMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 08:12:08 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35720 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaJZMMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 08:12:06 -0400
From: Peng Fan <van.freenix@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: daniel.vetter@ffwll.ch, kilobyte@angband.pl, dh.herrmann@gmail.com,
        petr.pisar@atlas.cz, tiwai@suse.de, van.freenix@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty:vt remove obsolete struct initializer
Date: Sun, 26 Oct 2014 20:08:02 +0800
Message-Id: <1414325282-32177-1-git-send-email-van.freenix@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sparse warning:
"obsolete struct initializer, use C99 syntax"

Signed-off-by: Peng Fan <van.freenix@gmail.com>
---
 drivers/tty/vt/vt.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index b33b00b..cf18bd4 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1367,9 +1367,11 @@ static void csi_m(struct vc_data *vc)
 						rgb_from_256(vc->vc_par[i]));
 				} else if (vc->vc_par[i] == 2 &&  /* 24 bit */
 				           i <= vc->vc_npar + 3) {/* extremely rare */
-					struct rgb c = {r:vc->vc_par[i+1],
-							g:vc->vc_par[i+2],
-							b:vc->vc_par[i+3]};
+					struct rgb c = {
+						.r = vc->vc_par[i + 1],
+						.g = vc->vc_par[i + 2],
+						.b = vc->vc_par[i + 3],
+					};
 					rgb_foreground(vc, c);
 					i += 3;
 				}
@@ -1388,9 +1390,11 @@ static void csi_m(struct vc_data *vc)
 						rgb_from_256(vc->vc_par[i]));
 				} else if (vc->vc_par[i] == 2 && /* 24 bit */
 				           i <= vc->vc_npar + 3) {
-					struct rgb c = {r:vc->vc_par[i+1],
-							g:vc->vc_par[i+2],
-							b:vc->vc_par[i+3]};
+					struct rgb c = {
+						.r = vc->vc_par[i + 1],
+						.g = vc->vc_par[i + 2],
+						.b = vc->vc_par[i + 3],
+					};
 					rgb_background(vc, c);
 					i += 3;
 				}
-- 
1.8.4

