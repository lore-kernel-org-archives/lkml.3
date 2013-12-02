Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3LBTO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:14:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3LBTOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>,
        Simon Wood <simon@mungewell.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 133/173] HID:hid-lg4ff: Switch autocentering off when strength is set to zero.
Date: Mon,  2 Dec 2013 11:11:56 -0800
Message-Id: <20131202191158.687866018@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wood <simon@mungewell.org>

commit d2c02da549b468bbb28e67d269bd3c9e10683ff5 upstream.

When the autocenter is set to zero, this patch issues a command to
totally disable the autocenter - this results in less resistance
in the wheel.

Reported-by: Elias Vanderstuyft <elias.vds@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-lg4ff.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -220,6 +220,20 @@ static void hid_lg4ff_set_autocenter_def
 	__s32 *value = report->field[0]->value;
 	__u32 expand_a, expand_b;
 
+	/* De-activate Auto-Center */
+	if (magnitude == 0) {
+		value[0] = 0xf5;
+		value[1] = 0x00;
+		value[2] = 0x00;
+		value[3] = 0x00;
+		value[4] = 0x00;
+		value[5] = 0x00;
+		value[6] = 0x00;
+
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+		return;
+	}
+
 	if (magnitude <= 0xaaaa) {
 		expand_a = 0x0c * magnitude;
 		expand_b = 0x80 * magnitude;
@@ -236,6 +250,17 @@ static void hid_lg4ff_set_autocenter_def
 	value[5] = 0x00;
 	value[6] = 0x00;
 
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+
+	/* Activate Auto-Center */
+	value[0] = 0x14;
+	value[1] = 0x00;
+	value[2] = 0x00;
+	value[3] = 0x00;
+	value[4] = 0x00;
+	value[5] = 0x00;
+	value[6] = 0x00;
+
 	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 


