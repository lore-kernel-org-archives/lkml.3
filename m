Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab3DWTH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:07:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51713 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab3DWTH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:07:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: [PATCH v2] usb: phy: don't mark usb_bind_phy as __init
Date: Tue, 23 Apr 2013 21:07:21 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <1366734653-488286-20-git-send-email-arnd@arndb.de> <20130423171734.GA31432@kroah.com>
In-Reply-To: <20130423171734.GA31432@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232107.22084.arnd@arndb.de>
X-Provags-ID: V02:K0:pY1yBMW/nogzeT+s67Hhz91ameukexp+ql26WM0qbjT
 ypVaipp2hLEn1BuiEMtzt80lwHVGEvX6mcCrKzg2ZH1ND+c/1u
 a7F05DppKuyyq+SooX1LXxiYDAZfp8pXaTT1rv2vUnfyPr20Yg
 xVSh1JF96zJlxdXkXFCvUZTVSSkGy+KQzSrC8GJa5Pvvi6Om6h
 htz9FDJ5Ka47AFbTbD3AWP5MKyPtmzhpP/pNX6JYgnyYihJNnZ
 d6K67Dtg0hgR9AHZcXISFk/F4nd1fkVGTX51ToX9SEy2VuyfGT
 IAZeyeHzhCTSVkZ69sypxLLYR6CzzCFr7XBMSyxbUBfetGsDyZ
 G11a3pLTZNZYUQuTXH/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes no sense for a symbol to be both exported and marked __init,
because any users in modules would be calling this function after
it gets discarded. Further, this patch revolves a section mismatch
warning from usbhs_init_phys(), which is intentionally not marked
__init:

WARNING: vmlinux.o(.text+0x413f8): Section mismatch in reference from
the function usbhs_init_phys() to the function .init.text:usb_bind_phy()

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---

v2: rebased on linux-next

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index f52c006..a9984c7 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -413,7 +413,7 @@ EXPORT_SYMBOL_GPL(usb_remove_phy);
  *
  * To be used by platform specific initialization code.
  */
-int __init usb_bind_phy(const char *dev_name, u8 index,
+int usb_bind_phy(const char *dev_name, u8 index,
 				const char *phy_dev_name)
 {
 	struct usb_phy_bind *phy_bind;
