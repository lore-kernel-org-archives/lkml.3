Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3AKWIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:08:44 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:38624 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab3AKWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:08:42 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Laurent Navet <laurent_navet@yahoo.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 6/6] staging: line6: avoid CamelCase POD_* enums in pod.c
Date: Fri, 11 Jan 2013 23:08:14 +0100
Message-Id: <1357942094-11495-7-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
References: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl warnings:

  WARNING: Avoid CamelCase: <POD_monitor_level>
  #4512: FILE: staging/line6/pod.c:41:
  +       POD_monitor_level  = 0x04,

  WARNING: Avoid CamelCase: <POD_system_invalid>
  #4513: FILE: staging/line6/pod.c:42:
  +       POD_system_invalid = 0x10000

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 1a11906..ba6fed4 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -40,8 +40,8 @@ enum {
 };
 
 enum {
-	POD_monitor_level  = 0x04,
-	POD_system_invalid = 0x10000
+	POD_MONITOR_LEVEL  = 0x04,
+	POD_SYSTEM_INVALID = 0x10000
 };
 
 /* *INDENT-ON* */
@@ -170,7 +170,7 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 								   << 8) |
 					    ((int)buf[9] << 4) | (int)buf[10];
 
-					if (buf[6] == POD_monitor_level)
+					if (buf[6] == POD_MONITOR_LEVEL)
 						pod->monitor_level = value;
 					break;
 				}
@@ -372,7 +372,7 @@ static int snd_pod_control_monitor_put(struct snd_kcontrol *kcontrol,
 
 	pod->monitor_level = ucontrol->value.integer.value[0];
 	pod_set_system_param_int(pod, ucontrol->value.integer.value[0],
-				 POD_monitor_level);
+				 POD_MONITOR_LEVEL);
 	return 1;
 }
 
@@ -463,7 +463,7 @@ static int pod_try_init(struct usb_interface *interface,
 	 */
 
 	if (pod->line6.properties->capabilities & LINE6_BIT_CONTROL) {
-		pod->monitor_level = POD_system_invalid;
+		pod->monitor_level = POD_SYSTEM_INVALID;
 
 		/* initiate startup procedure: */
 		pod_startup1(pod);
-- 
1.8.0.2

