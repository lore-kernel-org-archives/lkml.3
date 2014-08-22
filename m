Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbaHVRCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:02:30 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:37629 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511AbaHVRC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:02:29 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, linux-kernel@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH] Kconfig: do not select SPI bus on sub-driver auto-select
Date: Fri, 22 Aug 2014 20:02:09 +0300
Message-Id: <1408726929-3924-1-git-send-email-crope@iki.fi>
X-Mailer: git-send-email 1.9.3
X-SA-Exim-Connect-IP: 82.128.184.26
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not select SPI bus when sub-driver auto-select is
selected. That option is meant for auto-selecting all possible
ancillary drivers used for selected board driver. Ancillary
drivers should define needed dependencies itself.

I2C and I2C_MUX are still selected here for a reason described on
commit 347f7a3763601d7b466898d1f10080b7083ac4a3

Reverts commit e4462ffc1602d9df21c00a0381dca9080474e27a

Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index f60bad4..3c89fcb 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -182,7 +182,6 @@ config MEDIA_SUBDRV_AUTOSELECT
 	depends on HAS_IOMEM
 	select I2C
 	select I2C_MUX
-	select SPI
 	default y
 	help
 	  By default, a media driver auto-selects all possible ancillary
-- 
http://palosaari.fi/

