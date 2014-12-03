Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaLCXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:16:57 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48362 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLCXQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:16:54 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: mjg59@srcf.ucam.org, dvhart@infradead.org
Cc: pavel@ucw.cz, pali.rohar@gmail.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH 1/3] dell-wmi: Use appropriate keycode for radio state changes
Date: Thu,  4 Dec 2014 00:16:21 +0100
Message-Id: <1417648583-9336-2-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WMI events associated to KEY_WLAN are for all the radio devices
available. Use KEY_RFKILL instead since it's more appropriate.

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/platform/x86/dell-wmi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 25721bf..1e31fab 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -65,10 +65,9 @@ static const struct key_entry dell_wmi_legacy_keymap[] __initconst = {
 	/* Battery health status button */
 	{ KE_KEY, 0xe007, { KEY_BATTERY } },
 
-	/* This is actually for all radios. Although physically a
-	 * switch, the notification does not provide an indication of
-	 * state and so it should be reported as a key */
-	{ KE_KEY, 0xe008, { KEY_WLAN } },
+	/* Although physically a switch, the notification does not provide
+	 * an indication of state and so it should be reported as a key */
+	{ KE_KEY, 0xe008, { KEY_RFKILL } },
 
 	/* The next device is at offset 6, the active devices are at
 	   offset 8 and the attached devices at offset 10 */
-- 
2.1.3

