Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935380Ab3DHRrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:47:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:52133 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935219Ab3DHRrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:47:21 -0400
Message-ID: <51630297.2040803@infradead.org>
Date: Mon, 08 Apr 2013 10:47:03 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH -next] media:
References: <20130408174343.cc13eb1972470d20d38ecff1@canb.auug.org.au>
In-Reply-To: <20130408174343.cc13eb1972470d20d38ecff1@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix randconfig error when USB is not enabled:

ERROR: "usb_control_msg" [drivers/media/common/cypress_firmware.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Antti Palosaari <crope@iki.fi>
---
 drivers/media/common/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20130408.orig/drivers/media/common/Kconfig
+++ linux-next-20130408/drivers/media/common/Kconfig
@@ -18,6 +18,7 @@ config VIDEO_TVEEPROM
 
 config CYPRESS_FIRMWARE
 	tristate "Cypress firmware helper routines"
+	depends on USB
 
 source "drivers/media/common/b2c2/Kconfig"
 source "drivers/media/common/saa7146/Kconfig"
