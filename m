Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3LBTSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:18:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3LBTSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rafael Brune <mail@rbrune.de>, David Herrmann <dh.herrmann@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 143/212] HID: wiimote: fix inverted pro-controller axes
Date: Mon,  2 Dec 2013 11:15:34 -0800
Message-Id: <20131202191303.128346836@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-wiimote-modules.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-wiimote-modules.c
+++ b/drivers/hid/hid-wiimote-modules.c
@@ -1656,9 +1656,9 @@ static void wiimod_pro_in_ext(struct wii
 	ry = (ext[6] & 0xff) | ((ext[7] & 0x0f) << 8);
 
 	input_report_abs(wdata->extension.input, ABS_X, lx - 0x800);
-	input_report_abs(wdata->extension.input, ABS_Y, ly - 0x800);
+	input_report_abs(wdata->extension.input, ABS_Y, 0x800 - ly);
 	input_report_abs(wdata->extension.input, ABS_RX, rx - 0x800);
-	input_report_abs(wdata->extension.input, ABS_RY, ry - 0x800);
+	input_report_abs(wdata->extension.input, ABS_RY, 0x800 - ry);
 
 	input_report_key(wdata->extension.input,
 			 wiimod_pro_map[WIIMOD_PRO_KEY_RIGHT],


