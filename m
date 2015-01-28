Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbbA2BxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:53:04 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:53992 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbbA2BxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:53:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/7] [media] siano: fix Kconfig dependencies
Date: Wed, 28 Jan 2015 22:17:44 +0100
Message-Id: <1422479867-3370921-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 2.1.0.rc2
In-Reply-To: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V03:K0:EsC1bAKZ5Jvxtuek0F18orvO0oPbsGu6V2kRKfNRO751Iw2XCTS
 r/Sm60WBMwhCQvREh6UYXjxZw9bXhRb9OjMfan4pTi5WU92Aknd4PqgLtb5Zp40ReaMmfX4
 mgzbp2wMdnhaZnZZfclsA5j0Q3KvqOhtenWOtvGwCdKbZo3lbsPy/RZCNAboKnWhG1gKMEU
 JGgzkRhqlF9X5dbYTUKmQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB and MMC front-ends to the siano driver both only make
sense when combined with the SMS_SIANO_MDTV driver. That driver
already requires RC_CORE to not be a module, so we also need
to add that dependency here.

drivers/built-in.o: In function `smssdio_remove':
:(.text+0x155bd8): undefined reference to `smscore_putbuffer'
:(.text+0x155bdc): undefined reference to `smscore_unregister_device'
drivers/built-in.o: In function `smssdio_interrupt':
:(.text+0x155e4c): undefined reference to `smsendian_handle_rx_message'
:(.text+0x155e50): undefined reference to `smscore_onresponse'
:(.text+0x155e54): undefined reference to `smscore_getbuffer'
:(.text+0x155e58): undefined reference to `smscore_putbuffer'
drivers/built-in.o: In function `smssdio_sendrequest':
:(.text+0x155f20): undefined reference to `smsendian_handle_tx_message'
drivers/built-in.o: In function `smssdio_probe':
:(.text+0x15610c): undefined reference to `sms_get_board'
:(.text+0x156114): undefined reference to `smscore_register_device'
:(.text+0x156118): undefined reference to `smscore_set_board_id'
:(.text+0x156128): undefined reference to `smscore_unregister_device'
:(.text+0x156140): undefined reference to `smscore_start_device'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/mmc/siano/Kconfig | 2 ++
 drivers/media/usb/siano/Kconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/mmc/siano/Kconfig b/drivers/media/mmc/siano/Kconfig
index aa05ad3c1ccb..7693487e2f63 100644
--- a/drivers/media/mmc/siano/Kconfig
+++ b/drivers/media/mmc/siano/Kconfig
@@ -6,6 +6,8 @@ config SMS_SDIO_DRV
 	tristate "Siano SMS1xxx based MDTV via SDIO interface"
 	depends on DVB_CORE && HAS_DMA
 	depends on MMC
+	depends on !RC_CORE || RC_CORE
 	select MEDIA_COMMON_OPTIONS
+	select SMS_SIANO_MDTV
 	---help---
 	  Choose if you would like to have Siano's support for SDIO interface
diff --git a/drivers/media/usb/siano/Kconfig b/drivers/media/usb/siano/Kconfig
index 5afbd9a4b55c..d37b742d4f7a 100644
--- a/drivers/media/usb/siano/Kconfig
+++ b/drivers/media/usb/siano/Kconfig
@@ -5,7 +5,9 @@
 config SMS_USB_DRV
 	tristate "Siano SMS1xxx based MDTV receiver"
 	depends on DVB_CORE && HAS_DMA
+	depends on !RC_CORE || RC_CORE
 	select MEDIA_COMMON_OPTIONS
+	select SMS_SIANO_MDTV
 	---help---
 	  Choose if you would like to have Siano's support for USB interface
 
-- 
2.1.0.rc2

