Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaLCXQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:16:59 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47264 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaLCXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:16:57 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: mjg59@srcf.ucam.org, dvhart@infradead.org
Cc: pavel@ucw.cz, pali.rohar@gmail.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH 2/3] dell-wmi: Don't report keypresses for radio state changes
Date: Thu,  4 Dec 2014 00:16:22 +0100
Message-Id: <1417648583-9336-3-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The state of radio devices is changed directly by the BIOS when hotkeys
are pressed, so no events should be reported.

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/platform/x86/dell-wmi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 1e31fab..9d3507c 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -65,9 +65,8 @@ static const struct key_entry dell_wmi_legacy_keymap[] __initconst = {
 	/* Battery health status button */
 	{ KE_KEY, 0xe007, { KEY_BATTERY } },
 
-	/* Although physically a switch, the notification does not provide
-	 * an indication of state and so it should be reported as a key */
-	{ KE_KEY, 0xe008, { KEY_RFKILL } },
+	/* Radio devices state change */
+	{ KE_IGNORE, 0xe008, { KEY_RFKILL } },
 
 	/* The next device is at offset 6, the active devices are at
 	   offset 8 and the attached devices at offset 10 */
-- 
2.1.3

