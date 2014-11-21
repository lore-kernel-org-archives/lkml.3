Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaKUSXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:23:49 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64012 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKUSXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:23:47 -0500
From: Andreas Ruprecht <rupran@einserver.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au,
        Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH v2] media: pci: smipcie: Fix dependency for DVB_SMIPCIE
Date: Fri, 21 Nov 2014 19:23:28 +0100
Message-Id: <1416594208-29553-1-git-send-email-rupran@einserver.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20141121161316.23963dc5@recife.lan>
References: <20141121161316.23963dc5@recife.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In smipcie.c, the function i2c_bit_add_bus() is called. This
function is defined by the I2C bit-banging interfaces enabled
with CONFIG_I2C_ALGOBIT.

As there was no dependency in Kconfig, CONFIG_I2C_ALGOBIT could
be set to "m" while CONFIG_DVB_SMIPCIE was set to "y", resulting
in a build error due to an undefined reference.

This patch adds the dependency on CONFIG_I2C_ALGOBIT in Kconfig
by selecting it when CONFIG_DVB_SMIPCIE is selected.

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
Reported-by: Jim Davis <jim.epost@gmail.com>
---
 drivers/media/pci/smipcie/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/smipcie/Kconfig b/drivers/media/pci/smipcie/Kconfig
index 75a2992..57dd124 100644
--- a/drivers/media/pci/smipcie/Kconfig
+++ b/drivers/media/pci/smipcie/Kconfig
@@ -1,6 +1,7 @@
 config DVB_SMIPCIE
 	tristate "SMI PCIe DVBSky cards"
 	depends on DVB_CORE && PCI && I2C
+	select I2C_ALGOBIT
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
-- 
1.9.1

