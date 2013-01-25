Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3AYN3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:29:38 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:57082 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3AYNXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:36 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/25] HID: multitouch: fix Win8 protocol for Sharp like devices
Date: Fri, 25 Jan 2013 14:22:48 +0100
Message-Id: <1359120190-18281-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Sharp LC-20FE1-W screen (04dd:9681) behaves like the Nexio 42".
It may report out of ranges values that are filtered out by relying
on the Contact Count HID field.
Adding the quirk MT_QUIRK_CONTACT_CNT_ACCURATE makes hid-multitouch
strongest against this kind of device, without breaking the current
devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c4acdd0..8d0a9f9 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -317,6 +317,7 @@ static void mt_feature_mapping(struct hid_device *hdev,
 			*quirks |= MT_QUIRK_ALWAYS_VALID;
 			*quirks |= MT_QUIRK_IGNORE_DUPLICATES;
 			*quirks |= MT_QUIRK_HOVERING;
+			*quirks |= MT_QUIRK_CONTACT_CNT_ACCURATE;
 			*quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;
 			*quirks &= ~MT_QUIRK_VALID_IS_INRANGE;
 			*quirks &= ~MT_QUIRK_VALID_IS_CONFIDENCE;
-- 
1.8.1

