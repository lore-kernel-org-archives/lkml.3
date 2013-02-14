Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445Ab3BNNuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:50:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965196Ab3BNNuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:50:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-i2c@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 10/11] ARM: s3c: i2c: add platform_device forward declaration
Date: Thu, 14 Feb 2013 14:49:26 +0100
Message-Id: <1360849767-1463135-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:2/d9cFLJZloZjRaF72JAORq/Lt+2CSpHeHnOKopLpqU
 HHhvAFcrrVATwx+Hgsajpd7MTgRBw7lReQfzfChgCF9XXTguGV
 BzCMJ/j7IIkjF4cZFOe0IqNHQl0RkgHoOM403x8Kw74coP5MuZ
 Ggg6tlSP+NNcd+vWJNhpwe7XTPasWmIHOMonKj4dw9m3o7GYwg
 1OzP7380Nr5Cv4NANH2As2f2T5ab/eYlQgzQTNZDQVJfl5QnMo
 VUVXTHyT7Y/sCoOiS9jokcMvHXraqMpfg1RtiGnQdrFoRtaikw
 HfiPGRGVFkXz6axsTOkv5qAyTl3mXxrI87rwbP01nhOCtQMayN
 5F/XzAan3gkOLF4qIOfcgBp/vnpDTH7yZcio+12fM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent cleanup to the mach-osiris.c file is causing build errors
because the i2c-s3c2410.h header file is included before we see
the definition for platform_device. The fix is to make the header file
more robust against inclusion from other places. While this should
normally go through the i2c tree, the bug only exists in arm-soc
at the moment, so it's easier to fix it there before it goes upstream.

Without this patch, building s3c2410_defconfig results in:

arch/arm/mach-s3c24xx/mach-osiris.c:34:0:
include/linux/platform_data/i2c-s3c2410.h:37:26: warning: 'struct platform_device' declared inside parameter list [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 include/linux/platform_data/i2c-s3c2410.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/platform_data/i2c-s3c2410.h b/include/linux/platform_data/i2c-s3c2410.h
index 51d52e7..2a50048 100644
--- a/include/linux/platform_data/i2c-s3c2410.h
+++ b/include/linux/platform_data/i2c-s3c2410.h
@@ -15,6 +15,8 @@
 
 #define S3C_IICFLG_FILTER	(1<<0)	/* enable s3c2440 filter */
 
+struct platform_device;
+
 /**
  *	struct s3c2410_platform_i2c - Platform data for s3c I2C.
  *	@bus_num: The bus number to use (if possible).
-- 
1.8.1.2

