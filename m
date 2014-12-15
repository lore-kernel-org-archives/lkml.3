Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaLOQTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:19:15 -0500
Received: from mx02.posteo.de ([89.146.194.165]:32852 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaLOQTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:19:12 -0500
From: Martin Kepplinger <martink@posteo.de>
To: peterz@infradead.org
Cc: mingo@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 4/6] input: gtco: use bitops' sign_extend8
Date: Mon, 15 Dec 2014 17:18:35 +0100
Message-Id: <1418660317-21750-5-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418660317-21750-1-git-send-email-martink@posteo.de>
References: <1418660317-21750-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/input/tablet/gtco.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index 8580456..25b3834 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -59,7 +59,7 @@ Scott Hill shill@gtcocalcomp.com
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 #include <asm/byteorder.h>
-
+#include <linux/bitops.h>
 
 #include <linux/usb/input.h>
 
@@ -666,13 +666,8 @@ static void gtco_urb_callback(struct urb *urbinfo)
 		case 4:
 			/* Tilt */
 
-			/* Sign extend these 7 bit numbers.  */
-			if (device->buffer[6] & 0x40)
-				device->buffer[6] |= 0x80;
-
-			if (device->buffer[7] & 0x40)
-				device->buffer[7] |= 0x80;
-
+			device->buffer[6] = sign_extend8(device->buffer[6], 6);
+			device->buffer[7] = sign_extend8(device->buffer[6], 6);
 
 			valsigned = (device->buffer[6]);
 			input_report_abs(inputdev, ABS_TILT_X, (s32)valsigned);
-- 
2.1.3

