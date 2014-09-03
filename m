Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbaICPue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:50:34 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39033 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaICPuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:50:32 -0400
Message-ID: <540738C7.5000106@gmail.com>
Date: Wed, 03 Sep 2014 23:50:31 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: stern@rowland.harvard.edu
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, michal.simek@xilinx.com,
        linux-usb@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/usb/host/ehci-xilinx-of.c: Include "linux/of_irq.h"
 to avoid compiling error
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need include it for irq_of_parse_and_map(), the related error with
allmodconfig under microblaze:

  drivers/usb/host/ehci-xilinx-of.c: In function ‘ehci_hcd_xilinx_of_probe’:
  drivers/usb/host/ehci-xilinx-of.c:156:2: error: implicit declaration of function ‘irq_of_parse_and_map’ [-Werror=implicit-function-declaration]
    irq = irq_of_parse_and_map(dn, 0);
    ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/usb/host/ehci-xilinx-of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index fe57710..a232836 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -31,6 +31,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 /**
  * ehci_xilinx_port_handed_over - hand the port out if failed to enable it
-- 
1.9.3
