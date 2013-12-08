Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3LHW4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 17:56:24 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42007 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057Ab3LHWyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 17:54:25 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org (open list:USB OHCI DRIVER)
Subject: [PATCH 3/9] ARM: fix ohci-pxa27x build error with OF enabled
Date: Mon,  9 Dec 2013 02:53:43 +0400
Message-Id: <1386543229-1542-4-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
 <1386543229-1542-1-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--->8---
$ make
  CC [M]  drivers/usb/host/ohci-pxa27x.o
drivers/usb/host/ohci-pxa27x.c: In function ‘ohci_pxa_of_init’:
drivers/usb/host/ohci-pxa27x.c:310:2: error: implicit declaration of function ‘dma_coerce_mask_and_coherent’ [-Werror=implicit-function-declaration]
drivers/usb/host/ohci-pxa27x.c:310:2: error: implicit declaration of function ‘DMA_BIT_MASK’ [-Werror=implicit-function-declaration]
--->8---

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>

 # Changes to be committed:
---
 drivers/usb/host/ohci-pxa27x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ohci-pxa27x.c b/drivers/usb/host/ohci-pxa27x.c
index e89ac4d..97983fd 100644
--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -24,6 +24,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/dma-mapping.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_data/usb-ohci-pxa27x.h>
-- 
1.8.4.3

