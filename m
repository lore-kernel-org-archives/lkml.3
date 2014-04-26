Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaDZRHE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 13:07:04 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51691 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaDZRHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 13:07:02 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tiwai@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] staging: line6: fix possible overrun
Date: Sat, 26 Apr 2014 19:09:22 +0200
Message-Id: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The strcpy operation may write past the end of the fixed-size destination
buffer if the source buffer is too large.

Found by coverity scan : CID 144979

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
build tested only

 drivers/staging/line6/audio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/audio.c b/drivers/staging/line6/audio.c
index 171d80c..65f5cd4 100644
--- a/drivers/staging/line6/audio.c
+++ b/drivers/staging/line6/audio.c
@@ -32,9 +32,10 @@ int line6_init_audio(struct usb_line6 *line6)
 
 	line6->card = card;
 
-	strcpy(card->id, line6->properties->id);
+	strncpy(card->id, line6->properties->id, (sizeof(card->id)-1));
 	strcpy(card->driver, DRIVER_NAME);
-	strcpy(card->shortname, line6->properties->name);
+	strncpy(card->shortname, line6->properties->name,
+			(sizeof(card->shortname)-1));
 	/* longname is 80 chars - see asound.h */
 	sprintf(card->longname, "Line6 %s at USB %s", line6->properties->name,
 		dev_name(line6->ifcdev));
-- 
1.9.1

