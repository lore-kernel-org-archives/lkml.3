Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaFWIkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:40:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55596 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 050/111] USB: cdc-wdm: properly include types.h
Date: Mon, 23 Jun 2014 10:31:25 +0200
Message-Id: <1507358d93f24d74ba28704347873666e2b629e8.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7ac3764fcafc06e72e1a79a9d998b9fdd900b2a6 upstream.

The file include/uapi/linux/usb/cdc-wdm.h uses a __u16 so it needs to
include types.h as well to make the build system happy.

Fixes: 3edce1cf813a ("USB: cdc-wdm: implement IOCTL_WDM_MAX_COMMAND")
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/linux/usb/cdc-wdm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/usb/cdc-wdm.h b/include/uapi/linux/usb/cdc-wdm.h
index f03134feebd6..0dc132e75030 100644
--- a/include/uapi/linux/usb/cdc-wdm.h
+++ b/include/uapi/linux/usb/cdc-wdm.h
@@ -9,6 +9,8 @@
 #ifndef _UAPI__LINUX_USB_CDC_WDM_H
 #define _UAPI__LINUX_USB_CDC_WDM_H
 
+#include <linux/types.h>
+
 /*
  * This IOCTL is used to retrieve the wMaxCommand for the device,
  * defining the message limit for both reading and writing.
-- 
2.0.0

