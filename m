Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3JDVoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:44:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:33550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab3JDVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:44:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="388083555"
From: David Cohen <david.a.cohen@linux.intel.com>
To: gregkh@linuxfoundation.org, balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] usb: g_ffs: fix compilation warning
Date: Fri,  4 Oct 2013 14:48:46 -0700
Message-Id: <1380923326-18546-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to lack of "u_ether.h" header file, g_ffs.c compiles with following
warning:

drivers/usb/gadget/g_ffs.c:81:1: warning: data definition has no type or
storage class [enabled by default]
drivers/usb/gadget/g_ffs.c:81:1: warning: type defaults to ‘int’ in
declaration of ‘USB_ETHERNET_MODULE_PARAMETERS’ [-Wimplicit-int]
drivers/usb/gadget/g_ffs.c:81:1: warning: function declaration isn’t a
prototype [-Wstrict-prototypes]

This patch adds the missing header.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/g_ffs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 5327c82..ed3d9ab 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -13,6 +13,9 @@
 #define pr_fmt(fmt) "g_ffs: " fmt
 
 #include <linux/module.h>
+
+#include "u_ether.h"
+
 /*
  * kbuild is not very cooperative with respect to linking separately
  * compiled library objects into one module.  So for now we won't use
-- 
1.8.4.rc3

