Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3IKG5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:57:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3IKG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:56:45 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=w2o7ZPEbPh0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=izKDUj_K4XoA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042903.133271020@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: enrico Mioso <mrkiko.rs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [064/251] usb: serial: option: blacklist ONDA MT689DC QMI interface
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0064-usb-serial-option-blacklist-ONDA-MT689DC-QMI-interfa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Enrico Mioso <mrkiko.rs@gmail.com>

[ Upstream commit 3d1a69e726406ab662ab88fa30a3a05ed404334d ]

Prevent the option driver from binding itself to the QMI/WWAN interface, making
it unusable by the proper driver.

Signed-off-by: enrico Mioso <mrkiko.rs@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/option.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 27adfce..8b4ea07 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -805,7 +805,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0017, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0018, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0019, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0019, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0020, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0021, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
-- 
1.7.10.4


