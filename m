Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaIPQvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:51:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbaIPQvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:51:11 -0400
Subject: [PATCH] extcon: sm5502: Depend on I2C
From: Jean Delvare <jdelvare@suse.de>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 16 Sep 2014 18:51:06 +0200
Message-ID: <1410886266.3951.23.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SM5502 chip is an I2C device so its drivers must depend on I2C.
Failing to do so results in build failures on kernels where I2C is
not enabled.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -72,6 +72,7 @@ config EXTCON_PALMAS
 
 config EXTCON_SM5502
 	tristate "SM5502 EXTCON support"
+	depends on I2C
 	select IRQ_DOMAIN
 	select REGMAP_I2C
 	select REGMAP_IRQ

-- 
Jean Delvare
SUSE L3 Support

