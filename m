Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162553Ab3LFNXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:23:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161868Ab3LFNEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 208/272] HID: wiimote: fix inverted pro-controller axes
Date: Fri,  6 Dec 2013 12:58:17 +0000
Message-Id: <1386334761-25517-209-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@gmail.com>

commit 0abda6fa81dced031e3df31ac29bfb253549c2d1 upstream.

The analog-stick vertical axes are inverted. Fix that! Otherwise, games
and other gamepad applications need to carry their own fixups (which they
thankfully haven't done, yet).

Reported-by: Rafael Brune <mail@rbrune.de>
Tested-by: Rafael Brune <mail@rbrune.de>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-wiimote-modules.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-wiimote-modules.c b/drivers/hid/hid-wiimote-modules.c
index 71adf9e..e30567a 100644
--- a/drivers/hid/hid-wiimote-modules.c
+++ b/drivers/hid/hid-wiimote-modules.c
@@ -1656,9 +1656,9 @@ static void wiimod_pro_in_ext(struct wiimote_data *wdata, const __u8 *ext)
 	ry = (ext[6] & 0xff) | ((ext[7] & 0x0f) << 8);
 
 	input_report_abs(wdata->extension.input, ABS_X, lx - 0x800);
-	input_report_abs(wdata->extension.input, ABS_Y, ly - 0x800);
+	input_report_abs(wdata->extension.input, ABS_Y, 0x800 - ly);
 	input_report_abs(wdata->extension.input, ABS_RX, rx - 0x800);
-	input_report_abs(wdata->extension.input, ABS_RY, ry - 0x800);
+	input_report_abs(wdata->extension.input, ABS_RY, 0x800 - ry);
 
 	input_report_key(wdata->extension.input,
 			 wiimod_pro_map[WIIMOD_PRO_KEY_RIGHT],
-- 
1.8.3.2

