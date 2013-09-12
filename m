Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3ILR7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:59:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3ILR7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Gardner <robmatic@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/46] net: usb: Add HP hs2434 device to ZLP exception table
Date: Thu, 12 Sep 2013 10:58:39 -0700
Message-Id: <20130912175724.058925279@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Gardner <robmatic@gmail.com>

[ Upstream commit 03803a59e32453ee5737c6096a295f748f03cc49 ]

This patch adds another entry (HP hs2434 Mobile Broadband) to the list
of exceptional devices that require a zero length packet in order to
function properly. This list was added in commit 844e88f0. The hs2434
is manufactured by Sierra Wireless, who also produces the MC7710,
which the ZLP exception list was created for in the first place. So
hopefully it is just this one producer's devices that will need this
workaround.

Tested on a DM1-4310NR HP notebook, which does not function without this
change.

Signed-off-by: Rob Gardner <robmatic@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_mbim.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -400,6 +400,10 @@ static const struct usb_device_id mbim_d
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68a2, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
 	},
+	/* HP hs2434 Mobile Broadband Module needs ZLPs */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3f0, 0x4b1d, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
+	},
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info,
 	},


