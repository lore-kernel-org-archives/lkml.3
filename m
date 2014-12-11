Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbaLKMxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:53:02 -0500
Received: from lekensteyn.nl ([178.21.112.251]:35996 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbaLKMve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:51:34 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] HID: logitech-hidpp: add boundary check for name retrieval
Date: Thu, 11 Dec 2014 13:51:19 +0100
Message-Id: <1418302280-14794-4-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
References: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
X-Spam-Score: -0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HID response has a limited size. Do not trust the value returned by
hardware, check that it really fits in the message.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 drivers/hid/hid-logitech-hidpp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 4d72c20..4292cc3 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -313,6 +313,9 @@ static char *hidpp_get_unifying_name(struct hidpp_device *hidpp_dev)
 
 	len = response.rap.params[1];
 
+	if (2 + len > sizeof(response.rap.params))
+		return NULL;
+
 	name = kzalloc(len + 1, GFP_KERNEL);
 	if (!name)
 		return NULL;
-- 
2.1.3

