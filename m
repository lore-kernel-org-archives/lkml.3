Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaJAXLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 19:11:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39964 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaJAXLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 19:11:00 -0400
Date: Thu, 2 Oct 2014 00:10:57 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: storage: fix build warnings !CONFIG_PM
Message-ID: <20141001231057.GA25667@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions fw5895_init() and config_autodelink_before_power_down() are used
only when CONFIG_PM is defined.

drivers/usb/storage/realtek_cr.c:699:13: warning: 'fw5895_init' defined but not used [-Wunused-function]
drivers/usb/storage/realtek_cr.c:629:12: warning: 'config_autodelink_before_power_down' defined but not used [-Wunused-function]

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/realtek_cr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 281be56d5648..d3ba242b98e1 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -626,6 +626,7 @@ static int config_autodelink_after_power_on(struct us_data *us)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int config_autodelink_before_power_down(struct us_data *us)
 {
 	struct rts51x_chip *chip = (struct rts51x_chip *)(us->extra);
@@ -716,6 +717,7 @@ static void fw5895_init(struct us_data *us)
 		}
 	}
 }
+#endif
 
 #ifdef CONFIG_REALTEK_AUTOPM
 static void fw5895_set_mmc_wp(struct us_data *us)
-- 
2.1.0
