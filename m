Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbbAEW27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:28:59 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35570 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbbAEW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:28:54 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-kernel@vger.kernel.org, silverhammermba@gmail.com,
        peter.hutterer@who-t.net, hdegoede@redhat.com,
        benjamin.tissoires@gmail.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH v2 3/4] input: synaptics - change default width value of cr48 sensors
Date: Mon,  5 Jan 2015 23:28:34 +0100
Message-Id: <1420496915-31560-4-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
References: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The minimum value these sensors can report is 4, so this should be the
value used when W is not reporting the width.

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/input/mouse/synaptics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 918a727..5008e8c 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -910,7 +910,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 
 	if (hw.z > 0 && hw.x > 1) {
 		num_fingers = 1;
-		finger_width = 5;
+		finger_width = 4;
 		if (SYN_CAP_EXTENDED(priv->capabilities)) {
 			switch (hw.w) {
 			case 0 ... 1:
-- 
2.1.4

