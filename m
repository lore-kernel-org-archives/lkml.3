Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbaLIM3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:29:30 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:51583 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbaLIM30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:29:26 -0500
From: Daniel Nicoletti <dantti12@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Nicoletti <dantti12@gmail.com>
Subject: [PATCH] HID: Allow HID_BATTERY_STRENGTH to be enabled
Date: Tue,  9 Dec 2014 10:28:54 -0200
Message-Id: <1418128134-7997-1-git-send-email-dantti12@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows for HID_BATTERY_STRENGTH config be enabled
without the need for HID module to be built-in,
prior to this HID and POWER_SUPPLY had to be
equal, and now we only select POWER_SUPPLY and
depend on the HID module.

Signed-off-by: Daniel Nicoletti <dantti12@gmail.com>
---
 drivers/hid/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index f42df4d..602ac07 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -27,7 +27,8 @@ if HID
 
 config HID_BATTERY_STRENGTH
 	bool "Battery level reporting for HID devices"
-	depends on HID && POWER_SUPPLY && HID = POWER_SUPPLY
+	depends on HID
+	select POWER_SUPPLY
 	default n
 	---help---
 	This option adds support of reporting battery strength (for HID devices
-- 
2.1.0

