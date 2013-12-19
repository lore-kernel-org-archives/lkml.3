Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3LSKGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:06:17 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35598 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3LSKGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:06:12 -0500
Date: Thu, 19 Dec 2013 15:36:00 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthias Beyer <mail@beyermatthias.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 1/7] drivers: usb: Include appropriate header file in hcd.c
Message-ID: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file include/linux/usb/otg.h in core/hcd.c
because function usb_bus_start_enum() has its prototype declaration in
include/linux/usb/otg.h.

This eliminates the following warning in core/hcd.c:
drivers/usb/core/hcd.c:2295:5: warning: no previous prototype for ‘usb_bus_start_enum’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/usb/core/hcd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 6bffb8c..077be7c 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -44,6 +44,7 @@
 
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
+#include <linux/usb/otg.h>
 
 #include "usb.h"
 
-- 
1.7.9.5

