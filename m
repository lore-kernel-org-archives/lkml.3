Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753AbaE2Rvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:51:46 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:45994 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2Rvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:51:45 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/18] staging: rtl8188eu: Use rtw_hal_sreset_init() in rtw_reset_drv_sw()
Date: Thu, 29 May 2014 23:20:43 +0530
Message-Id: <1401385858-28722-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can replace rtw_hal_sreset_reset_value() with rtw_hal_sreset_init() because
both function call sreset_reset_value() and sreset_init_value() respectively at
the end of code path, and function defination of sreset_reset_value() and
sreset_init_value() is identical.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/os_intfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 0e0c32d..6fe32f0 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -837,8 +837,7 @@ u8 rtw_reset_drv_sw(struct adapter *padapter)
 	pmlmepriv->LinkDetectInfo.bBusyTraffic = false;
 
 	_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY | _FW_UNDER_LINKING);
-
-	rtw_hal_sreset_reset_value(padapter);
+	rtw_hal_sreset_init(padapter);
 	pwrctrlpriv->pwr_state_check_cnts = 0;
 
 	/* mlmeextpriv */
-- 
1.7.10.4

