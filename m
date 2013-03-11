Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3CKRnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:43:16 -0400
Received: from smtp-out-222.synserver.de ([212.40.185.222]:1077 "EHLO
	smtp-out-222.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3CKRnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:43:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32201
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Bi Chao <chao.bi@intel.com>,
        Chen Jun <jun.d.chen@intel.com>
Subject: [PATCH 4/4] tty: ifx6x60: Remove unused suspend/resume callbacks
Date: Mon, 11 Mar 2013 18:44:52 +0100
Message-Id: <1363023892-15957-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1363023892-15957-1-git-send-email-lars@metafoo.de>
References: <1363023892-15957-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ifx6x60 driver implements both legacy suspend/resume callbacks and
dev_pm_ops. The SPI core is going to ignore legacy suspend/resume
callbacks if a driver implements dev_pm_ops. Since the legacy suspend/resume
callbacks are empty in this case it is safe to just remove them.

Cc: Bi Chao <chao.bi@intel.com>
Cc: Chen Jun <jun.d.chen@intel.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/tty/serial/ifx6x60.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 68d7ce9..ae63c14 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -1325,30 +1325,6 @@ static void ifx_spi_spi_shutdown(struct spi_device *spi)
  */
 
 /**
- *	ifx_spi_spi_suspend	-	suspend SPI on system suspend
- *	@dev: device being suspended
- *
- *	Suspend the SPI side. No action needed on Intel MID platforms, may
- *	need extending for other systems.
- */
-static int ifx_spi_spi_suspend(struct spi_device *spi, pm_message_t msg)
-{
-	return 0;
-}
-
-/**
- *	ifx_spi_spi_resume	-	resume SPI side on system resume
- *	@dev: device being suspended
- *
- *	Suspend the SPI side. No action needed on Intel MID platforms, may
- *	need extending for other systems.
- */
-static int ifx_spi_spi_resume(struct spi_device *spi)
-{
-	return 0;
-}
-
-/**
  *	ifx_spi_pm_suspend	-	suspend modem on system suspend
  *	@dev: device being suspended
  *
@@ -1437,8 +1413,6 @@ static struct spi_driver ifx_spi_driver = {
 	.probe = ifx_spi_spi_probe,
 	.shutdown = ifx_spi_spi_shutdown,
 	.remove = ifx_spi_spi_remove,
-	.suspend = ifx_spi_spi_suspend,
-	.resume = ifx_spi_spi_resume,
 	.id_table = ifx_id_table
 };
 
-- 
1.8.0

