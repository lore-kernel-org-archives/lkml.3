Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3LSKJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:09:16 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44403 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3LSKJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:09:13 -0500
Date: Thu, 19 Dec 2013 15:39:05 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 3/7] drivers: usb: Include appropriate header file in hcd.h
Message-ID: <026c3f34e6c26d5456940c28a0f33da96064e023.1387439261.git.rashika.kheria@gmail.com>
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

Include header file include/linux/usb.h in include/linux/usb/hcd.h
because structures usb_device, usb_host_config and usb_interface have
their definitions in include/linux/usb.h.

This eliminates the following warning in include/linux/usb/hcd.h:
include/linux/usb/hcd.h:311:44: warning: ‘struct usb_device’ declared inside parameter list [enabled by default]
include/linux/usb/hcd.h:412:10: warning: ‘struct usb_host_config’ declared inside parameter list [enabled by default]
include/linux/usb/hcd.h:614:9: warning: ‘struct usb_interface’ declared inside parameter list [enabled by default]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/usb/hcd.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index b8aba19..f312ce4 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -23,6 +23,7 @@
 
 #include <linux/rwsem.h>
 #include <linux/interrupt.h>
+#include <linux/usb.h>
 
 #define MAX_TOPO_LEVEL		6
 
-- 
1.7.9.5

