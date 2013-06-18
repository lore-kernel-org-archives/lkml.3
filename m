Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3FRJVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:21:19 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34289 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3FRJVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:21:14 -0400
Date: Tue, 18 Jun 2013 17:21:04 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
To: matthew.garrett@nebula.com, bhutchings@solarflare.com
cc: platform-driver-x86@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        jim.epost@gmail.com
Subject: [PATCH]amilo-rfkill: add depends on i8042 in Kconfig
Message-ID: <alpine.DEB.2.02.1306181705530.28460@M2420>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiong Zhou <jencce.kernel@gmail.com>

Fix randconfig build failure for Amilo x86 platform driver.
AMILO_RFKILL requires SERIO_I8042 being available.

amilo-rfkill.c:(.text+0x108b5b): undefined reference to `i8042_lock_chip'
amilo-rfkill.c:(.text+0x108b69): undefined reference to `i8042_command'
amilo-rfkill.c:(.text+0x108b71): undefined reference to `i8042_unlock_chip'

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 8577261..37645b9 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -176,6 +176,7 @@ config FUJITSU_TABLET
 config AMILO_RFKILL
 	tristate "Fujitsu-Siemens Amilo rfkill support"
 	depends on RFKILL
+	depends on SERIO_I8042
 	---help---
 	  This is a driver for enabling wifi on some Fujitsu-Siemens Amilo
 	  laptops.
