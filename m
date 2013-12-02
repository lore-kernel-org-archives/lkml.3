Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3LBXfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:35:32 -0500
Received: from [195.81.139.13] ([195.81.139.13]:35262 "EHLO
	soller.eu.logitech.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752575Ab3LBXf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:35:29 -0500
X-Greylist: delayed 1067 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 18:35:29 EST
From: Olivier Gay <ogay@logitech.com>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Olivier Gay <ogay@logitech.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Mathieu Meisser <mmeisser@logitech.com>
Subject: [PATCH] HID: logitech-dj: add HIDRAW dependency in Kconfig
Date: Tue,  3 Dec 2013 00:17:24 +0100
Message-Id: <1386026244-21553-1-git-send-email-ogay@logitech.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid-logitech-dj.c driver needs hidraw to work correctly. Without
hidraw, hid-logitech-dj.c fails during probe() and Logitech
Unifying devices HID reports aren't recognized.

Signed-off-by: Olivier Gay <ogay@logitech.com>
Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
Signed-off-by: Mathieu Meisser <mmeisser@logitech.com>
---

Hi everyone,

this adds a HIDRAW dependency in Kconfig for hid-logitech-dj.c
driver. The driver uses hidraw and needs it to work correctly.

Without hidraw if a Logitech Unifying device is plugged, the driver
fails during probe() and Logitech Unifying devices HID reports aren't
recognized. This has been the cause of some confusion. Some Linux and
Android distributions had HID_LOGITECH_DJ enabled without HIDRAW and
the Unifying mice and keyboards would simply not work (no cursor
tracking / no keyboard typing).

Best regards,

Olivier

 drivers/hid/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 329fbb9..c8a66b9 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -344,6 +344,7 @@ config HID_LOGITECH
 
 config HID_LOGITECH_DJ
 	tristate "Logitech Unifying receivers full support"
+	depends on HIDRAW
 	depends on HID_LOGITECH
 	---help---
 	Say Y if you want support for Logitech Unifying receivers and devices.
-- 
1.8.4

