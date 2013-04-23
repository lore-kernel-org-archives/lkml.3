Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3DWQb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:31:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab3DWQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:31:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 19/21] usb: phy: don't mark usb_bind_phy as __init
Date: Tue, 23 Apr 2013 18:30:51 +0200
Message-Id: <1366734653-488286-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:qb0T5pBLrjnV57Baxtl+EcieOySM0ht9IVqLJkLEXn5
 aMd002sojXxLUgvDLOwH3Bv4Naa1yF7E5qFfoyt1g6rsorUe3D
 llzpq/QpiHdyEb/3B6pvNReL1ZSl8Gso9ardg9+pBSbnzOmk2q
 aNpeKdHJzTm/uMb/UC5aZsBq0F0QfeKcPtSIdfBULNYqFD0RSp
 sLgYPf7ITJgYWpKFQs6SzuNOKkS3JgVlmJpUiqYaxfvV5B4Tv4
 VJw4KvhDC2/whyHXCc9QgnRY0XWkcWEUONLdidbJ7/aA8oVIVZ
 UpMTzpSKzs8EEO7fgg8m7XcaqrkxxU4SoMMbFNTNZtWPInSzEm
 fJslkuy75JuCn/H//34Uz4El2Hehxbrq6Ikc6l6R2
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
 drivers/usb/otg/otg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index 2bd03d2..77346cf 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -414,7 +414,7 @@ EXPORT_SYMBOL(usb_remove_phy);
  *
  * To be used by platform specific initialization code.
  */
-int __init usb_bind_phy(const char *dev_name, u8 index,
+int usb_bind_phy(const char *dev_name, u8 index,
 				const char *phy_dev_name)
 {
 	struct usb_phy_bind *phy_bind;
-- 
1.8.1.2

