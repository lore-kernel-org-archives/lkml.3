Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbbA2CSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:18:44 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:52143 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157AbbA2Bx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:53:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5/7] [media] gspca: add INPUT dependency
Date: Wed, 28 Jan 2015 22:17:45 +0100
Message-Id: <1422479867-3370921-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 2.1.0.rc2
In-Reply-To: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V03:K0:gj+DL5dUvP24g5PzeA+Tc6UlY4BI6r3ZKr525GcnwEN9lUjfHKB
 bPIisP43JeUwy9frfpLf/q7bKEBeSgcwOm4qqdiyrp8WeO4j9+LE/Xjw440mE/xUYxkAIBb
 ioc38H7Rns9F15Owmy2I9iEVOCD+NjKnuh9utPfjx4kSuaVZYlR2pc9HeZj/UnBRH684UJD
 QRnSnzWiOtyAWmIC2y8yA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gspca  driver uses the input_event infrastructure and fails
to link if that is not available:

drivers/built-in.o: In function `gspca_disconnect':
media/usb/gspca/gspca.c:2171: undefined reference to `input_unregister_device'
drivers/built-in.o: In function `gspca_dev_probe2':
media/usb/gspca/gspca.c:2112: undefined reference to `input_allocate_device'
media/usb/gspca/gspca.c:2112: undefined reference to `input_register_device'
media/usb/gspca/gspca.c:2112: undefined reference to `input_unregister_device'
media/usb/gspca/gspca.c:2112: undefined reference to `input_free_device'
drivers/built-in.o: In function `sd_int_pkt_scan':
media/usb/gspca/pac207.c:428: undefined reference to `input_event'
drivers/built-in.o: In function `sd_int_pkt_scan':
media/usb/gspca/pac7302.c:879: undefined reference to `input_event'
drivers/built-in.o: In function `sd_int_pkt_scan':
media/usb/gspca/se401.c:612: undefined reference to `input_event'
drivers/built-in.o: In function `sd_stop0':
media/usb/gspca/xirlink_cit.c:2742: undefined reference to `input_event'
drivers/built-in.o: In function `cit_check_button':
media/usb/gspca/xirlink_cit.c:2935: undefined reference to `input_event'
drivers/built-in.o:/git/arm-soc/include/linux/input.h:414: more undefined references to `input_event' follow

This adds an explicit dependency.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/gspca/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index eed10d782535..2b23aad5a9f2 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -1,6 +1,7 @@
 menuconfig USB_GSPCA
 	tristate "GSPCA based webcams"
 	depends on VIDEO_V4L2
+	depends on INPUT
 	default m
 	---help---
 	  Say Y here if you want to enable selecting webcams based
-- 
2.1.0.rc2

