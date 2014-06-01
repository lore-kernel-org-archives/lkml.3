Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaFANWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:22:49 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62019 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaFANWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:22:48 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Manu Gupta <manugupt1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:23:40 +0200
Message-Id: <1401629020-18518-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 2e49cd5..fd37360 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -776,7 +776,7 @@ static void rtw_usb_if1_deinit(struct adapter *if1)
 static int rtw_drv_init(struct usb_interface *pusb_intf, const struct usb_device_id *pdid)
 {
 	struct adapter *if1 = NULL;
-	int status;
+	int status = _FAIL;
 	struct dvobj_priv *dvobj;
 
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_init\n"));
-- 
1.7.10.4

