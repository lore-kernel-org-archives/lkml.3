Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3LSKH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:07:56 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34541 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3LSKHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:07:53 -0500
Date: Thu, 19 Dec 2013 15:37:37 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 2/7] drivers: usb: Include appropriate header file in
 configfs.c
Message-ID: <81b82e653766ab5d9712445000a953a264165356.1387439261.git.rashika.kheria@gmail.com>
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file drivers/usb/gadget/configfs.h in
gadget/configfs.c because function unregister_gadget_item() has its
prototype declaration in gadget/configfs.h.

This eliminates the following warning in gadget/configfs.c:
drivers/usb/gadget/configfs.c:994:6: warning: no previous prototype for ‘unregister_gadget_item’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/usb/gadget/configfs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 2588511..a117ec2 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 #include <linux/usb/composite.h>
 #include <linux/usb/gadget_configfs.h>
+#include "configfs.h"
 
 int check_user_usb_string(const char *name,
 		struct usb_gadget_strings *stringtab_dev)
-- 
1.7.9.5

