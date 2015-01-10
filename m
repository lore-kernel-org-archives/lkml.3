Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbbAJFgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:36:42 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35241 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbAJFg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:29 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 02/25] staging: line6: Remove line6_pod_transmit_paramter()
Date: Fri,  9 Jan 2015 23:35:48 -0600
Message-Id: <1420868171-2031-3-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was no longer used as of commit 2807904441d4 (staging:
line6: drop MIDI parameter sysfs attrs).

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/pod.c | 9 ---------
 drivers/staging/line6/pod.h | 2 --
 2 files changed, 11 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 44f4b2f..7b4ec92f 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -159,15 +159,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 }
 
 /*
-	Transmit PODxt Pro control parameter.
-*/
-void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
-				  u8 value)
-{
-	line6_transmit_parameter(&pod->line6, param, value);
-}
-
-/*
 	Send system parameter (from integer).
 */
 static int pod_set_system_param_int(struct usb_line6_pod *pod, int value,
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 3e3f167..397d94c 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -96,7 +96,5 @@ extern void line6_pod_disconnect(struct usb_interface *interface);
 extern int line6_pod_init(struct usb_interface *interface,
 			  struct usb_line6_pod *pod);
 extern void line6_pod_process_message(struct usb_line6_pod *pod);
-extern void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
-					 u8 value);
 
 #endif
-- 
2.1.0

