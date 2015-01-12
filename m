Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbbALR2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:28:44 -0500
Received: from mx02.posteo.de ([89.146.194.165]:45168 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbbALR2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:28:43 -0500
From: Martin Kepplinger <martink@posteo.de>
To: mingo@kernel.org
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com, tytso@mit.edu,
        maxime.coquelin@st.com, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [RFC] input: gtco: use bitops' sign_extend8
Date: Mon, 12 Jan 2015 18:28:17 +0100
Message-Id: <1421083700-25258-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421083370-24924-1-git-send-email-martink@posteo.de>
References: <1421083370-24924-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example change, using new sign_extend functions.
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
2.1.4

