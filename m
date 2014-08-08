Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbaHHUrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:47:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40462 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbaHHUqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 256/259] net: huawei_cdc_ncm: add "subclass 3" devices
Date: Fri,  8 Aug 2014 13:41:19 -0700
Message-Id: <1407530482-4483-257-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit c2a6c7813f1ffae636e369b5d7011c9f518d3cd9 ]

Huawei's usage of the subclass and protocol fields is not 100%
clear to us, but there appears to be a very strict system.

A device with the "shared" device ID 12d1:1506 and this NCM
function was recently reported (showing only default altsetting):

    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      3
      bInterfaceProtocol     22
      iInterface              8 CDC Network Control Model (NCM)
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  06 24 1a 00 01 1f
      ** UNRECOGNIZED:  0c 24 1b 00 01 00 04 10 14 dc 05 20
      ** UNRECOGNIZED:  0d 24 0f 0a 0f 00 00 00 ea 05 03 00 01
      ** UNRECOGNIZED:  05 24 06 01 01
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               9

Cc: Enrico Mioso <mrkiko.rs@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/huawei_cdc_ncm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/huawei_cdc_ncm.c b/drivers/net/usb/huawei_cdc_ncm.c
index 75d9ee4..a014625 100644
--- a/drivers/net/usb/huawei_cdc_ncm.c
+++ b/drivers/net/usb/huawei_cdc_ncm.c
@@ -207,6 +207,9 @@ static const struct usb_device_id huawei_cdc_ncm_devs[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x12d1, 0xff, 0x02, 0x76),
 	  .driver_info = (unsigned long)&huawei_cdc_ncm_info,
 	},
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x12d1, 0xff, 0x03, 0x16),
+	  .driver_info = (unsigned long)&huawei_cdc_ncm_info,
+	},
 
 	/* Terminating entry */
 	{
-- 
1.9.1

