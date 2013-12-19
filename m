Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3LSKK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:10:57 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63816 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3LSKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:10:54 -0500
Date: Thu, 19 Dec 2013 15:40:40 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 4/7] drivers: usb: Include appropriate header file in
 pci-quirks.c
Message-ID: <e0ff2366ddbd62f75e8597008b1f3f9001224ad6.1387439261.git.rashika.kheria@gmail.com>
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

Include header file include/linux/usb/hcd.h in host/pci-quirks.c because
function usb_hcd_amd_remote_wakeup_quirk() has its prototype declaration
in include/linux/usb/hcd.h.

This eliminates the following warning in host/pci-quirks.c:
drivers/usb/host/pci-quirks.c:253:5: warning: no previous prototype for ‘usb_hcd_amd_remote_wakeup_quirk’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/usb/host/pci-quirks.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index dfbdd3a..4574953 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -17,6 +17,7 @@
 #include <linux/export.h>
 #include <linux/acpi.h>
 #include <linux/dmi.h>
+#include <linux/usb/hcd.h>
 #include "pci-quirks.h"
 #include "xhci-ext-caps.h"
 
-- 
1.7.9.5

