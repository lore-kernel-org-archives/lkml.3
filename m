Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaJIVE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:04:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaJIVDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 018/163] USB: sierra: avoid CDC class functions on "68A3" devices
Date: Thu,  9 Oct 2014 14:00:43 -0700
Message-Id: <1412888588-26755-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 049255f51644c1105775af228396d187402a5934 upstream.

Sierra Wireless Direct IP devices using the 68A3 product ID
can be configured for modes including a CDC ECM class function.
The known example uses interface numbers 12 and 13 for the ECM
control and data interfaces respectively, consistent with CDC
MBIM function interface numbering on other Sierra devices.

It seems cleaner to restrict this driver to the ff/ff/ff
vendor specific interfaces rather than increasing the already
long interface number blacklist.  This should be more future
proof if Sierra adds more class functions using interface
numbers not yet in the blacklist.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/sierra.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index b6910b7..aa69283 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -281,14 +281,16 @@ static const struct usb_device_id id_table[] = {
 	/* Sierra Wireless HSPA Non-Composite Device */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6892, 0xFF, 0xFF, 0xFF)},
 	{ USB_DEVICE(0x1199, 0x6893) },	/* Sierra Wireless Device */
-	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
+	/* Sierra Wireless Direct IP modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68A3, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 	/* AT&T Direct IP LTE modems */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68AA, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
-	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
+	/* Airprime/Sierra Wireless Direct IP modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68A3, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 
-- 
1.9.1

