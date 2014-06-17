Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967432AbaFQWTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:19:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965643AbaFQVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 194/212] USB: cdc-wdm: properly include types.h
Date: Tue, 17 Jun 2014 14:44:48 -0700
Message-Id: <1403041506-13646-195-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7ac3764fcafc06e72e1a79a9d998b9fdd900b2a6 upstream.

The file include/uapi/linux/usb/cdc-wdm.h uses a __u16 so it needs to
include types.h as well to make the build system happy.

Fixes: 3edce1cf813a ("USB: cdc-wdm: implement IOCTL_WDM_MAX_COMMAND")
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/uapi/linux/usb/cdc-wdm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/usb/cdc-wdm.h b/include/uapi/linux/usb/cdc-wdm.h
index f03134f..0dc132e 100644
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
1.9.1

