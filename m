Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab3J2BIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:08:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:61520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709Ab3J2BIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400167040"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH 1/2] usb: gadget: re-introduce gadget_is_dwc3()
Date: Mon, 28 Oct 2013 18:12:59 -0700
Message-Id: <1383009180-23236-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383009180-23236-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383009180-23236-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gadget_is_dwc3() is necessary to check whether we are running on
Desineware USB3 DRD controller.

This macro was previously removed by commit
ed9cbda63d45638b69ce62412e3a3c7b00644835 due to it wasn't needed
anymore. We're adding it again as things have changed.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/gadget_chips.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/gadget_chips.h b/drivers/usb/gadget/gadget_chips.h
index bcd04bc..3186a5e 100644
--- a/drivers/usb/gadget/gadget_chips.h
+++ b/drivers/usb/gadget/gadget_chips.h
@@ -28,6 +28,7 @@
  * do that for you.
  */
 #define gadget_is_at91(g)		(!strcmp("at91_udc", (g)->name))
+#define gadget_is_dwc3(g)		(!strcmp("dwc3-gadget", (g)->name))
 #define gadget_is_goku(g)		(!strcmp("goku_udc", (g)->name))
 #define gadget_is_musbhdrc(g)		(!strcmp("musb-hdrc", (g)->name))
 #define gadget_is_net2280(g)		(!strcmp("net2280", (g)->name))
-- 
1.8.4.rc3

