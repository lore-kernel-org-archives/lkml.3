Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab3JJQNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:13:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52578 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab3JJPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rob Gardner <robmatic@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 018/104] net: usb: Add HP hs2434 device to ZLP exception table
Date: Thu, 10 Oct 2013 08:41:06 -0700
Message-Id: <1381419752-29733-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/cdc_mbim.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 6bd9167..353d0b8 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -395,6 +395,10 @@ static const struct usb_device_id mbim_devs[] = {
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
-- 
1.8.1.2

