Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3ASBXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:23:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:57321 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab3ASBWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:22:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 14/16] USB: option: blacklist network interface on ONDA MT8205 4G LTE
Date: Fri, 18 Jan 2013 17:21:52 -0800
Message-Id: <20130119012140.320472221@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119012138.680057206@linuxfoundation.org>
References: <20130119012138.680057206@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

Signed-off-by: Bjørn Mork <bjorn@mork.no>

commit 2291dff02e5f8c708a46a7c4c888f2c467e26642 upstream.

The driver description files gives these names to the vendor specific
functions on this modem:

 Diag   VID_19D2&PID_0265&MI_00
 NMEA   VID_19D2&PID_0265&MI_01
 AT cmd VID_19D2&PID_0265&MI_02
 Modem  VID_19D2&PID_0265&MI_03
 Net    VID_19D2&PID_0265&MI_04

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -934,7 +934,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0254, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0257, 0xff, 0xff, 0xff), /* ZTE MF821 */
 	  .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0265, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0265, 0xff, 0xff, 0xff), /* ONDA MT8205 */
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0284, 0xff, 0xff, 0xff), /* ZTE MF880 */
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0317, 0xff, 0xff, 0xff) },


