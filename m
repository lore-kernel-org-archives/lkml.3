Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3HPP2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:28:36 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63936 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3HPP2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:28:02 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 1/2] usb: gadget: ffs: fix eth module parameters warning in pure-only config
Date: Fri, 16 Aug 2013 11:27:47 -0400
Message-Id: <1376666868-32581-2-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376666868-32581-1-git-send-email-matt.porter@linaro.org>
References: <1376666868-32581-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the build warning spewed out by USB_ETHERNET_MODULE_PARAMETERS()
which was unconditionally included even when ethernet configs are
disabled.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 drivers/usb/gadget/g_ffs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 5327c82..686b776 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -45,6 +45,7 @@ static struct eth_dev *the_dev;
 static int eth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN],
 		struct eth_dev *dev);
 #  endif
+USB_ETHERNET_MODULE_PARAMETERS();
 #else
 #  define the_dev	NULL
 #  define gether_cleanup(dev) do { } while (0)
@@ -76,8 +77,6 @@ struct gfs_ffs_obj {
 
 USB_GADGET_COMPOSITE_OPTIONS();
 
-USB_ETHERNET_MODULE_PARAMETERS();
-
 static struct usb_device_descriptor gfs_dev_desc = {
 	.bLength		= sizeof gfs_dev_desc,
 	.bDescriptorType	= USB_DT_DEVICE,
-- 
1.7.9.5

