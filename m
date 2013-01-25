Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab3AYNXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:23:54 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:63226 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab3AYNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:48 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/25] HID: multitouch: optimize Cypress panels
Date: Fri, 25 Jan 2013 14:22:53 +0100
Message-Id: <1359120190-18281-9-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relying on ALWAYS_VALID enhance a little the processing time of
the events.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 199e320..c15b588 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -195,7 +195,8 @@ static struct mt_class mt_classes[] = {
 		.maxcontacts = 60,
 	},
 	{ .name = MT_CLS_CYPRESS,
-		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_CYPRESS,
 		.maxcontacts = 10 },
 	{ .name = MT_CLS_EGALAX,
-- 
1.8.1

