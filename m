Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3JDW0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:26:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:54064 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3JDW0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1036,1371106800"; 
   d="scan'208";a="414206637"
From: David Cohen <david.a.cohen@linux.intel.com>
To: gregkh@linuxfoundation.org, balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v2] usb: g_ffs: fix compilation warning
Date: Fri,  4 Oct 2013 15:30:21 -0700
Message-Id: <1380925821-12848-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If USB_FUNCTIONFS is selected without USB_FUNCTIONFS_ETH and
USB_FUNCTIONFS_RNIS, u_ether.h won't be included and then
USB_ETHERNET_MODULE_PARAMAETERS macro won't be available causing the
following warning compilation:

drivers/usb/gadget/g_ffs.c:81:1: warning: data definition has no type or
storage class [enabled by default]
drivers/usb/gadget/g_ffs.c:81:1: warning: type defaults to ‘int’ in
declaration of ‘USB_ETHERNET_MODULE_PARAMETERS’ [-Wimplicit-int]
drivers/usb/gadget/g_ffs.c:81:1: warning: function declaration isn’t a
prototype [-Wstrict-prototypes]

This patch fixes the warning by making USB_ETHERNET_MODULE_PARAMETERS to
be used iff u_ether.h is included, otherwise it is not needed.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/g_ffs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 5327c82..2344efe 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -76,7 +76,9 @@ struct gfs_ffs_obj {
 
 USB_GADGET_COMPOSITE_OPTIONS();
 
+#if defined CONFIG_USB_FUNCTIONFS_ETH || defined CONFIG_USB_FUNCTIONFS_RNDIS
 USB_ETHERNET_MODULE_PARAMETERS();
+#endif
 
 static struct usb_device_descriptor gfs_dev_desc = {
 	.bLength		= sizeof gfs_dev_desc,
-- 
1.8.4.rc3

