Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3D0CJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 22:09:18 -0400
Received: from host171.canaca.com ([67.55.55.225]:42202 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3D0CJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 22:09:13 -0400
X-Greylist: delayed 2224 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2013 22:09:13 EDT
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, djovic78@gmail.com, madcatxster@gmail.com
Subject: [PATCH] HID: hid-lg4ff add support for new version of DFGT wheel
Date: Fri, 26 Apr 2013 19:29:54 -0600
Message-Id: <1367026194-2103-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.8.1.2
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been reported that there is a new version (different USB rev)
of the Logitech DFGT in the 'wild'.

This patch allows the kernel to recognise this wheel and send it the
command to enter native mode.

Reported-by: "Denis Jovic" <djovic78@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 65a6ec8..2dd7360 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -34,6 +34,7 @@
 
 #define DFGT_REV_MAJ 0x13
 #define DFGT_REV_MIN 0x22
+#define DFGT2_REV_MIN 0x26
 #define DFP_REV_MAJ 0x11
 #define DFP_REV_MIN 0x06
 #define FFEX_REV_MAJ 0x21
@@ -125,6 +126,7 @@ static const struct lg4ff_native_cmd native_g27 = {
 
 static const struct lg4ff_usb_revision lg4ff_revs[] = {
 	{DFGT_REV_MAJ, DFGT_REV_MIN, &native_dfgt},	/* Driving Force GT */
+	{DFGT_REV_MAJ, DFGT2_REV_MIN, &native_dfgt},	/* Driving Force GT v2 */
 	{DFP_REV_MAJ,  DFP_REV_MIN,  &native_dfp},	/* Driving Force Pro */
 	{G25_REV_MAJ,  G25_REV_MIN,  &native_g25},	/* G25 */
 	{G27_REV_MAJ,  G27_REV_MIN,  &native_g27},	/* G27 */
-- 
1.8.1.2

