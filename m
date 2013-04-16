Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938Ab3DPPdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:33:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:59231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab3DPPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:33:37 -0400
Message-ID: <516D6F42.7000709@infradead.org>
Date: Tue, 16 Apr 2013 08:33:22 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: David Rientjes <rientjes@google.com>, Antti Palosaari <crope@iki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH -next] staging/media: fix go7007 dependencies and build
References: <20130408174343.cc13eb1972470d20d38ecff1@canb.auug.org.au> <51630297.2040803@infradead.org> <516461FE.4020007@iki.fi> <alpine.DEB.2.02.1304152010180.3952@chino.kir.corp.google.com> <20130416061243.22d06140@redhat.com>
In-Reply-To: <20130416061243.22d06140@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

VIDEO_GO7007 uses usb interfaces so it should depend on USB.
It also selects CYPRESS_FIRMWARE, which depends on USB.

Fixes build errors and a kconfig warning:

go7007-loader.c:(.text+0xcc7d0): undefined reference to `usb_get_dev'
go7007-loader.c:(.init.text+0x49f0): undefined reference to `usb_register_driver'
go7007-loader.c:(.exit.text+0x17ce): undefined reference to `usb_deregister'

warning: (DVB_USB_AZ6007 && VIDEO_GO7007) selects CYPRESS_FIRMWARE which has unmet direct dependencies (MEDIA_SUPPORT && USB)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/staging/media/go7007/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20130416.orig/drivers/staging/media/go7007/Kconfig
+++ linux-next-20130416/drivers/staging/media/go7007/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_GO7007
 	tristate "WIS GO7007 MPEG encoder support"
 	depends on VIDEO_DEV && I2C
-	depends on SND
+	depends on SND && USB
 	select VIDEOBUF2_VMALLOC
 	select VIDEO_TUNER
 	select CYPRESS_FIRMWARE
