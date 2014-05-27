Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaE0PhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:37:17 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61695 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaE0PhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:37:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/15] staging: rtl8188eu:Drop rtw_handle_dualmac() function calls in rtw_usb_if1_deinit()
Date: Tue, 27 May 2014 21:05:48 +0530
Message-Id: <1401204955-4093-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_usb_if1_init() assign NULL to pbuddy_padapter variable which is not
being used.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index aa93cd0..7b1c774 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -654,7 +654,6 @@ static void rtw_usb_if1_deinit(struct adapter *if1)
 	rtw_dev_unload(if1);
 	DBG_88E("+r871xu_dev_remove, hw_init_completed=%d\n",
 		if1->hw_init_completed);
-	rtw_handle_dualmac(if1, 0);
 	rtw_free_drv_sw(if1);
 	if (pnetdev)
 		rtw_free_netdev(pnetdev);
-- 
1.7.10.4

