Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaE0Pgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:36:46 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40565 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaE0Pgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:36:42 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/15] staging: rtl8188eu:Assign RTL8188E to padapter->chip_type directly
Date: Tue, 27 May 2014 21:05:44 +0530
Message-Id: <1401204955-4093-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign RTL8188E to padapter->chip_type directly instead of calling
chip_by_usb_id() function to do same.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index a368aa9..fbf967d 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -546,11 +546,8 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 	dvobj->if1 = padapter;
 
 	padapter->bDriverStopped = true;
-
 	padapter->hw_init_mutex = &usb_drv->hw_init_mutex;
-
-	/* step 1-1., decide the chip_type via vid/pid */
-	chip_by_usb_id(padapter, pdid);
+	padapter->chip_type = RTL8188E;
 
 	if (rtw_handle_dualmac(padapter, 1) != _SUCCESS)
 		goto free_adapter;
-- 
1.7.10.4

