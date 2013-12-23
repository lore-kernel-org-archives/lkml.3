Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab3LWVzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:55:49 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58393 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab3LWVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:55:22 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 23 Dec 2013 13:55:13 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: rtl8188eu: Drop print of build date/time
Message-ID: <d50d2e14a689b41986fbfc27dc9312553ed60ebf.1387833347.git.josh@joshtriplett.org>
References: <cover.1387833347.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387833347.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already has this information, and individual drivers
shouldn't duplicate that.  This also eliminates the use of __DATE__ and
__TIME__, which make the build non-deterministic.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 7d14779..d44f606 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -865,7 +865,6 @@ static int __init rtw_drv_entry(void)
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_entry\n"));
 
 	DBG_88E(DRV_NAME " driver version=%s\n", DRIVERVERSION);
-	DBG_88E("build time: %s %s\n", __DATE__, __TIME__);
 
 	rtw_suspend_lock_init();
 
-- 
1.8.5.2

