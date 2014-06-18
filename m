Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaFRTfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:35:01 -0400
Received: from mout.gmx.net ([212.227.15.19]:54658 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbaFRTfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:35:00 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] cris: sync_serial: incorrect port in error message
Date: Wed, 18 Jun 2014 21:34:34 +0200
Message-Id: <1403120074-27098-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.0.0
X-Provags-ID: V03:K0:NgQms5FIjVEdp39O/LapqVDHAx8aWu3+4cssoGQ4HDHGFL5MuD7
 N51WPOR/eCl6QJMzvjPe1IkS5tdKebEF1EkpyIrZVubIozVLeCyAQMD6Hgm/NAGYj25vIYc
 vf1ny3NiEufvRUJjgnDBMSAqZF8qlE6pe31H7mQ6BMprzCtyF9El1HRyjnlYgU34+m5bTyY
 S9/sfwyVru1fzaNc+v2mQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message for port 1 outputs "port 0".

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 arch/cris/arch-v32/drivers/sync_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index bbb806b..a289423 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -280,7 +280,7 @@ static int __init etrax_sync_serial_init(void)
 #if defined(CONFIG_ETRAX_SYNCHRONOUS_SERIAL_PORT1)
 	if (crisv32_pinmux_alloc_fixed(pinmux_sser1)) {
 		printk(KERN_WARNING
-			"Unable to alloc pins for synchronous serial port 0\n");
+			"Unable to alloc pins for synchronous serial port 1\n");
 		return -EIO;
 	}
 	ports[1].enabled = 1;
-- 
2.0.0

