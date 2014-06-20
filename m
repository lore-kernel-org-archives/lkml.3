Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaFTPAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:00:22 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37581 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaFTPAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:00:18 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/41] staging: rtl8188eu: Rename hal_EfusePowerSwitch_RTL8188E()
Date: Fri, 20 Jun 2014 20:29:07 +0530
Message-Id: <1403276387-11841-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename hal_EfusePowerSwitch_RTL8188E() to rtl8188e_EfusePowerSwitch() and
remove original rtl8188e_EfusePowerSwitch(), so that driver can call
hal_EfusePowerSwitch_RTL8188E() directly without going through
rtl8188e_EfusePowerSwitch().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 58426ac..fdf2acb 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -751,7 +751,7 @@ hal_EfusePgPacketWriteData(
 		bool bPseudoTest);
 
 static void
-hal_EfusePowerSwitch_RTL8188E(
+rtl8188e_EfusePowerSwitch(
 		struct adapter *pAdapter,
 		u8 bWrite,
 		u8 PwrState)
@@ -800,16 +800,6 @@ hal_EfusePowerSwitch_RTL8188E(
 	}
 }
 
-static void
-rtl8188e_EfusePowerSwitch(
-		struct adapter *pAdapter,
-		u8 bWrite,
-		u8 PwrState)
-{
-	hal_EfusePowerSwitch_RTL8188E(pAdapter, bWrite, PwrState);
-}
-
-
 static void Hal_EfuseReadEFuse88E(struct adapter *Adapter,
 	u16			_offset,
 	u16			_size_byte,
-- 
1.7.10.4

