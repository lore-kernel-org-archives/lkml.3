Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3AKWJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:09:25 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:50248 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3AKWIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:08:39 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Laurent Navet <laurent_navet@yahoo.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 4/6] staging: line6: wrap lines to 80 chars in pod.c
Date: Fri, 11 Jan 2013 23:08:12 +0100
Message-Id: <1357942094-11495-5-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
References: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl warnings:

  WARNING: line over 80 characters
  #4508: FILE: staging/line6/pod.c:37:
  +       /* POD_SYSEX_DUMPMEM2  = 0x76 */   /* dumps entire internal memory of PODxt Pro */

  WARNING: line over 80 characters
  #4630: FILE: staging/line6/pod.c:159:
  +               if (memcmp(buf + 1, line6_midi_id, sizeof(line6_midi_id)) == 0) {

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index e542540..1a11906 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -34,7 +34,9 @@ enum {
 	POD_SYSEX_DUMPMEM   = 0x73,
 	POD_SYSEX_DUMP      = 0x74,
 	POD_SYSEX_DUMPREQ   = 0x75
-	/* POD_SYSEX_DUMPMEM2  = 0x76 */   /* dumps entire internal memory of PODxt Pro */
+
+	/* dumps entire internal memory of PODxt Pro */
+	/* POD_SYSEX_DUMPMEM2  = 0x76 */
 };
 
 enum {
@@ -156,7 +158,8 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 
 	case LINE6_SYSEX_BEGIN | LINE6_CHANNEL_DEVICE:
 	case LINE6_SYSEX_BEGIN | LINE6_CHANNEL_UNKNOWN:
-		if (memcmp(buf + 1, line6_midi_id, sizeof(line6_midi_id)) == 0) {
+		if (memcmp(buf + 1, line6_midi_id,
+			   sizeof(line6_midi_id)) == 0) {
 			switch (buf[5]) {
 			case POD_SYSEX_DUMP:
 				break;
-- 
1.8.0.2

