Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaKJTAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:00:48 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:65080 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaKJTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:00:46 -0500
From: Giedrius Statkevicius <giedriuswork@gmail.com>
To: dvhart@infradead.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        jim.epost@gmail.com,
        =?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?= <giedriuswork@gmail.com>
Subject: [PATCH] platform: hp_accel: Add SERIO_I8042 as a dependency since it now includes i8042.h/serio.h
Date: Mon, 10 Nov 2014 20:59:42 +0200
Message-Id: <1415645982-9472-1-git-send-email-giedriuswork@gmail.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make hp_accel dependent on SERIO_I8042 in the Kconfig because since commit
a4c724d0723b078e4ab4670e557cda1795036a7a ('platform: hp_accel: add a i8042
filter to remove HPQ6000 data from kb bus stream') hp_accel includes i8042.h
and serio.h.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
---
 drivers/platform/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 4dcfb71..7d146e68 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -202,6 +202,7 @@ config TC1100_WMI
 config HP_ACCEL
 	tristate "HP laptop accelerometer"
 	depends on INPUT && ACPI
+        depends on SERIO_I8042
 	select SENSORS_LIS3LV02D
 	select NEW_LEDS
 	select LEDS_CLASS
-- 
2.1.3

