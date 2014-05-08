Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaEHNwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:52:43 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52832 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaEHNwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:52:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org
Subject: [PATCH 3/8] usb: musb: omap2plus bus glue needs USB host support
Date: Thu,  8 May 2014 15:52:16 +0200
Message-Id: <1399557141-1346645-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:2aIqxpQfD4YDN/OHLnpFk9bXmE7PCJWeojyzrhlcz1q
 JWUkNRGFTAwOUMqzaXPqIZjTiGZWXRlJ/KyvZ886VjaSzIt4Lw
 FJv4xphBCwp7SZ6sjbXIhdJAQkvA+18B8O/aCgZVoNofCETBiT
 YOnH20n9oOgQiCtWuP5ZN9wFi6FmUPK0C13HPKPP34XY9ewEPV
 NNZzTe+/Jy4lYLZslAXYek6lsen0biDMKTOr1yemf/YeyYGrzS
 AHlGt7dgwFQwt4fcli2Pef8GvJu3svOJ3lQitBE8fCYlN7zABj
 whnFuPZCdJk90of1YWg2fEjksQKDhIXcJOz06FKliqfNve4iKJ
 l3+RgH3vts+qWT9zuv+pcHzwwIjPX43+2gnvyyzxs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The musb/omap2430.c bus glue driver calls usb_hcd_poll_rh_status,
which is only available if CONFIG_USB is also set, i.e. we
are building USB host mode and not just endpoint mode.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org
---
 drivers/usb/musb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 618b152..fce762c 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -76,7 +76,7 @@ config USB_MUSB_TUSB6010
 
 config USB_MUSB_OMAP2PLUS
 	tristate "OMAP2430 and onwards"
-	depends on ARCH_OMAP2PLUS
+	depends on ARCH_OMAP2PLUS && USB
 	select GENERIC_PHY
 
 config USB_MUSB_AM35X
-- 
1.8.3.2

