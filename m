Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469Ab3EBPUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:20:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111Ab3EBPQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH, RFC 19/22] staging/solo6x10: depend on CONFIG_FONTS
Date: Thu,  2 May 2013 17:16:23 +0200
Message-Id: <1367507786-505303-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:7a/hpGnYgXqS5wbxsISPgKbesekkazf++nl5qxqCk0S
 DBY3WgfDGDjjda8d9R78iJFWrzz3rpjZkSNbUks6XoIoQsppW8
 zr0iz0BfWnrqgPN2zqfaHgXQgXbPUDz0lWjXjHzzMhg5cUBgUC
 vSM0WeFwnLIUkeLhF1P5lPAEhj9rcd0FxglynwCxrkRMJcaEXL
 mj1VCfS8a3MrycdXJ17HM+ZGSmk/fcjO3XoxtlDLsOz+4I7aiF
 BNuCHEcZggbE28vpg6RIYqRTg4j4EcAWW6ThhdS8WGq/mP78WB
 BvqS8wDoK7e+FTyQmrre6Z7a2J1fZcCf3YsLXQ4XPgzJ68CnIn
 bgQbf6xLOxymgSEUFx0Xmx+Oz3ljcDWrkaY3MfaU1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new SOLO6X10 driver needs the built-in console fonts, specifically
the VGA8x16 font and building it without console support results in
a link error error.

drivers/built-in.o: In function `solo_osd_print':
 :(.text+0x7d3424): undefined reference to `find_font'

This adds a dependency on the CONFIG_FONTS symbol and changes the
console code to always build the base driver even if there are
no specific fonts built-in.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/solo6x10/Kconfig | 1 +
 drivers/video/console/Makefile         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
index ec32776..df6569b 100644
--- a/drivers/staging/media/solo6x10/Kconfig
+++ b/drivers/staging/media/solo6x10/Kconfig
@@ -1,6 +1,7 @@
 config SOLO6X10
 	tristate "Softlogic 6x10 MPEG codec cards"
 	depends on PCI && VIDEO_DEV && SND && I2C
+	depends on FONTS
 	select VIDEOBUF2_DMA_SG
 	select VIDEOBUF2_DMA_CONTIG
 	select SND_PCM
diff --git a/drivers/video/console/Makefile b/drivers/video/console/Makefile
index a862e91..48da25c 100644
--- a/drivers/video/console/Makefile
+++ b/drivers/video/console/Makefile
@@ -18,6 +18,8 @@ font-objs-$(CONFIG_FONT_MINI_4x6)  += font_mini_4x6.o
 
 font-objs += $(font-objs-y)
 
+obj-$(CONFIG_FONTS) += font.o
+
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_DUMMY_CONSOLE)       += dummycon.o
-- 
1.8.1.2

