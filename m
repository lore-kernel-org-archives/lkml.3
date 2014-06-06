Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaFFQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:16:58 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47629 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaFFQQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:16:56 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c: Cleaning up unnecessary code
Date: Fri,  6 Jun 2014 21:45:20 +0530
Message-Id: <1402071320-14400-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Removes unnecessary code that does not do anything useful.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 2e49cd5..fb3789e 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -563,14 +563,8 @@ static int rtw_resume(struct usb_interface *pusb_intf)
 {
 	struct dvobj_priv *dvobj = usb_get_intfdata(pusb_intf);
 	struct adapter *padapter = dvobj->if1;
-	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
-	 int ret = 0;
 
-	if (pwrpriv->bInternalAutoSuspend)
-		ret = rtw_resume_process(padapter);
-	else
-		ret = rtw_resume_process(padapter);
-	return ret;
+	return rtw_resume_process(padapter);
 }
 
 int rtw_resume_process(struct adapter *padapter)
-- 
1.7.10.4
