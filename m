Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3HUAxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:53:31 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64312 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3HUAx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:53:29 -0400
Date: Wed, 21 Aug 2013 08:53:15 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        platform-driver-x86@vger.kernel.org, jim.epost@gmail.com,
        jencce.kernel@gmail.com
Subject: [PATCH] amilo-rfkill: add Kconfig depends on i8042
Message-ID: <alpine.DEB.2.02.1308210849530.4098@M2420>
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
Acked-by: Ben Hutchings <ben@decadent.org.uk>
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
