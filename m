Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3DVCNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:13:45 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:49929 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3DVCNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:13:42 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 4/5] usb: chipidea: depend on CONFIG_OF instead of CONFIG_OF_DEVICE
Date: Sun, 21 Apr 2013 21:13:17 -0500
Message-Id: <1366596798-9457-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

CONFIG_OF_DEVICE is going away, so use CONFIG_OF instead. It does not
appear that CONFIG_OF_DEVICE was the correct dependency either.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/chipidea/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
index d92ca32..0895e3e 100644
--- a/drivers/usb/chipidea/Makefile
+++ b/drivers/usb/chipidea/Makefile
@@ -16,6 +16,6 @@ ifneq ($(CONFIG_PCI),)
 	obj-$(CONFIG_USB_CHIPIDEA)	+= ci13xxx_pci.o
 endif
 
-ifneq ($(CONFIG_OF_DEVICE),)
+ifneq ($(CONFIG_OF),)
 	obj-$(CONFIG_USB_CHIPIDEA)	+= ci13xxx_imx.o usbmisc_imx6q.o
 endif
-- 
1.7.10.4

