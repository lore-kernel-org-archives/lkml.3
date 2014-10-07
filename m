Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaJGJVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:21:48 -0400
Received: from ygrex.ru ([5.19.241.250]:49528 "EHLO ygrex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbaJGJVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:21:35 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2014 05:21:34 EDT
Date: Tue, 7 Oct 2014 13:11:42 +0400
From: Igor Bogomazov <ygrex@ygrex.ru>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] staging: rtl8188eu: coding style fixup
Message-ID: <20141007131142.56ef73a7@ygrex-lenovo>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pk tiny fix
get rid of 2 warnings and 2 errors for hal/fw.c
    
Signed-off-by: Igor Bogomazov <ygrex@ygrex.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: navin patidar <navin.patidar@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
linux-next 3.17.0

diff --git a/drivers/staging/rtl8188eu/hal/fw.c b/drivers/staging/rtl8188eu/hal/fw.c
index 17b7f37..c4293df 100644
--- a/drivers/staging/rtl8188eu/hal/fw.c
+++ b/drivers/staging/rtl8188eu/hal/fw.c
@@ -154,9 +154,8 @@ static int _rtl88e_fw_free_to_go(struct adapter *adapt)
 			break;
 	} while (counter++ < POLLING_READY_TIMEOUT_COUNT);
 
-	if (counter >= POLLING_READY_TIMEOUT_COUNT) {
+	if (counter >= POLLING_READY_TIMEOUT_COUNT)
 		goto exit;
-	}
 
 	value32 = usb_read32(adapt, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
@@ -193,13 +192,13 @@ int rtl88eu_download_fw(struct adapter *adapt)
 	u32 fwsize;
 	int err;
 
-	if (request_firmware(&fw, fw_name, device)){
+	if (request_firmware(&fw, fw_name, device)) {
 		dev_err(device, "Firmware %s not available\n", fw_name);
 		return -ENOENT;
 	}
 
 	if (fw->size > FW_8188E_SIZE) {
-		dev_err(device,"Firmware size exceed 0x%X. Check it.\n",
+		dev_err(device, "Firmware size exceed 0x%X. Check it.\n",
 			 FW_8188E_SIZE);
 		return -1;
 	}
@@ -226,7 +225,8 @@ int rtl88eu_download_fw(struct adapter *adapt)
 		rtl88e_firmware_selfreset(adapt);
 	}
 	_rtl88e_enable_fw_download(adapt, true);
-	usb_write8(adapt, REG_MCUFWDL, usb_read8(adapt, REG_MCUFWDL) | FWDL_ChkSum_rpt);
+	usb_write8(adapt, REG_MCUFWDL,
+		usb_read8(adapt, REG_MCUFWDL) | FWDL_ChkSum_rpt);
 	_rtl88e_write_fw(adapt, pfwdata, fwsize);
 	_rtl88e_enable_fw_download(adapt, false);
