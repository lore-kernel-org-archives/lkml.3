Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaFFR2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:28:11 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60321 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaFFRYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:24:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/13] staging: rtl8188eu: usb_halinit.c: Remove ReadAdapterInfo8188EU()
Date: Fri,  6 Jun 2014 22:54:33 +0530
Message-Id: <1402075473-26416-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index e60b5e9..316c821 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1187,7 +1187,7 @@ static void _ReadRFType(struct adapter *Adapter)
 	haldata->rf_chip = RF_6052;
 }

-static int _ReadAdapterInfo8188EU(struct adapter *Adapter)
+static void _ReadAdapterInfo8188EU(struct adapter *Adapter)
 {
 	u32 start = jiffies;

@@ -1197,13 +1197,6 @@ static int _ReadAdapterInfo8188EU(struct adapter *Adapter)
 	_ReadPROMContent(Adapter);

 	MSG_88E("<==== %s in %d ms\n", __func__, rtw_get_passing_time_ms(start));
-
-	return _SUCCESS;
-}
-
-static void ReadAdapterInfo8188EU(struct adapter *Adapter)
-{
-	_ReadAdapterInfo8188EU(Adapter);
 }

 #define GPIO_DEBUG_PORT_NUM 0
@@ -2249,7 +2242,7 @@ void rtl8188eu_set_hal_ops(struct adapter *adapt)

 	halfunc->init_default_value = &rtl8188eu_init_default_value;
 	halfunc->intf_chip_configure = &rtl8188eu_interface_configure;
-	halfunc->read_adapter_info = &ReadAdapterInfo8188EU;
+	halfunc->read_adapter_info = &_ReadAdapterInfo8188EU;

 	halfunc->SetHwRegHandler = &SetHwReg8188EU;
 	halfunc->GetHwRegHandler = &GetHwReg8188EU;
--
1.7.10.4

