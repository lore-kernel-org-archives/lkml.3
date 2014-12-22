Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaLVOlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:41:47 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36402 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbaLVOlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:41:45 -0500
From: Daniele Forsi <dforsi@gmail.com>
To: Henk Vergonet <Henk.Vergonet@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: usbb2k-api-dev@nongnu.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniele Forsi <dforsi@gmail.com>
Subject: [RFC PATCH 2/2] USB: input: yealink.c: add mapping for "RING" and "MUTE" keys
Date: Mon, 22 Dec 2014 15:41:09 +0100
Message-Id: <1419259269-23820-3-git-send-email-dforsi@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419259269-23820-1-git-send-email-dforsi@gmail.com>
References: <1419259269-23820-1-git-send-email-dforsi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the user manual of the "VOIP-3 SKY" USB phone, the RING
key is used to select different ring tones and the MUTE key is used
to mute the microphone.

Signed-off-by: Daniele Forsi <dforsi@gmail.com>
---
 drivers/input/misc/yealink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index e9403da..0b86c49 100644
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -189,7 +189,9 @@ static int setChar(struct yealink_dev *yld, int el, int chr)
  * USB-P1K button layout:
  *
  *             up
+ *            ring
  *       IN           OUT
+ *            mute
  *            down
  *
  *     pickup   C    hangup
@@ -207,7 +209,9 @@ static int map_p1k_to_key(int scancode)
 	switch(scancode) {		/* phone key:	*/
 	case 0x23: return KEY_LEFT;	/*   IN		*/
 	case 0x33: return KEY_UP;	/*   up		*/
+	case 0x44: return KEY_SOUND;	/*   ring	*/
 	case 0x04: return KEY_RIGHT;	/*   OUT	*/
+	case 0x41: return KEY_MICMUTE;	/*   mute	*/
 	case 0x24: return KEY_DOWN;	/*   down	*/
 	case 0x03: return KEY_ENTER;	/*   pickup	*/
 	case 0x14: return KEY_BACKSPACE; /*  C		*/
-- 
2.1.3

