Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaLGV4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 16:56:30 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54511 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaLGV43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 16:56:29 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: os_dep: usb_ops_linux.c:  Remove unused function
Date: Sun,  7 Dec 2014 22:59:07 +0100
Message-Id: <1417989547-18140-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function usb_writeN() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/include/usb_ops_linux.h |    1 -
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c  |   27 ---------------------
 2 files changed, 28 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/usb_ops_linux.h b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
index 01b3810..4fdc536 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops_linux.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
@@ -79,7 +79,6 @@ void usb_read_port_cancel(struct adapter *adapter);
 int usb_write8(struct adapter *adapter, u32 addr, u8 val);
 int usb_write16(struct adapter *adapter, u32 addr, u16 val);
 int usb_write32(struct adapter *adapter, u32 addr, u32 val);
-int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 
 u32 usb_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void usb_write_port_cancel(struct adapter *adapter);
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index ba1e178..b46061c 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -615,33 +615,6 @@ int usb_write32(struct adapter *adapter, u32 addr, u32 val)
 	return ret;
 }
 
-int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata)
-{
-	u8 request;
-	u8 requesttype;
-	u16 wvalue;
-	u16 index;
-	u16 len;
-	u8 buf[VENDOR_CMD_MAX_DATA_LEN] = {0};
-	int ret;
-
-
-	request = 0x05;
-	requesttype = 0x00;/* write_out */
-	index = 0;/* n/a */
-
-	wvalue = (u16)(addr&0x0000ffff);
-	len = length;
-	 memcpy(buf, pdata, len);
-
-	ret = usbctrl_vendorreq(adapter, request, wvalue, index, buf, len, requesttype);
-
-
-	return RTW_STATUS_CODE(ret);
-}
-
-
-
 static void usb_write_port_complete(struct urb *purb, struct pt_regs *regs)
 {
 	struct xmit_buf *pxmitbuf = (struct xmit_buf *)purb->context;
-- 
1.7.10.4

