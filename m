Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3LSKOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:14:45 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60623 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3LSKOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:14:42 -0500
Date: Thu, 19 Dec 2013 15:44:34 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 7/7] drivers: usb: Include appropriate header file in
 phy-am335x-control.c
Message-ID: <117b58d812d640846b3ff1f522585f1c3344f47f.1387439261.git.rashika.kheria@gmail.com>
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

Include header file drivers/usb/phy/am35x-phy-control.h in
phy/phy-am335x-control.c because function am335x_get_phy_control() has
its prototype declaration in drivers/usb/phy/am35x-phy-control.h.

Also, remove definition of structure phy_control because it is already
defined in the included header.

This eliminates the following warning in phy/phy-am335x-control.c:
drivers/usb/phy/phy-am335x-control.c:114:21: warning: no previous prototype for ‘am335x_get_phy_control’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/usb/phy/phy-am335x-control.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/usb/phy/phy-am335x-control.c b/drivers/usb/phy/phy-am335x-control.c
index 634f49a..d75196a 100644
--- a/drivers/usb/phy/phy-am335x-control.c
+++ b/drivers/usb/phy/phy-am335x-control.c
@@ -3,11 +3,7 @@
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/io.h>
-
-struct phy_control {
-	void (*phy_power)(struct phy_control *phy_ctrl, u32 id, bool on);
-	void (*phy_wkup)(struct phy_control *phy_ctrl, u32 id, bool on);
-};
+#include "am35x-phy-control.h"
 
 struct am335x_control_usb {
 	struct device *dev;
-- 
1.7.9.5

