Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3AYN3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:29:02 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:39874 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab3AYNXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:43 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/25] HID: multitouch: optimize FlatFrog panels
Date: Fri, 25 Jan 2013 14:22:51 +0100
Message-Id: <1359120190-18281-7-git-send-email-benjamin.tissoires@gmail.com>
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
 drivers/hid/hid-multitouch.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5a886bd..7dfe891 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -229,8 +229,9 @@ static struct mt_class mt_classes[] = {
 	},
 
 	{ .name = MT_CLS_FLATFROG,
-		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
-			MT_QUIRK_NO_AREA,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_NO_AREA |
+			MT_QUIRK_CONTACT_CNT_ACCURATE,
 		.sn_move = 2048,
 		.maxcontacts = 40,
 	},
-- 
1.8.1

