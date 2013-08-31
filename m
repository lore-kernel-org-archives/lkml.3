Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3HaLmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:42:39 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56899 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756482Ab3HaLme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:42:34 -0400
X-Sasl-enc: NSuaWHvOgfk0CJ7I11F8rhT0EK5BZf4e8U63CFYM0mt4 1377949353
Subject: [PATCH 02/10] autofs4 - fix string.h include in auto_dev-ioctl.h
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 Aug 2013 19:42:31 +0800
Message-ID: <20130831114231.11807.17131.stgit@perseus.themaw.net>
In-Reply-To: <20130831114133.11807.35953.stgit@perseus.themaw.net>
References: <20130831114133.11807.35953.stgit@perseus.themaw.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since including linux/string.h will now do the right thing remove the
conditional check.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 include/linux/auto_dev-ioctl.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/auto_dev-ioctl.h b/include/linux/auto_dev-ioctl.h
index 850f39b..fe4f373 100644
--- a/include/linux/auto_dev-ioctl.h
+++ b/include/linux/auto_dev-ioctl.h
@@ -11,12 +11,7 @@
 #define _LINUX_AUTO_DEV_IOCTL_H
 
 #include <linux/auto_fs.h>
-
-#ifdef __KERNEL__
 #include <linux/string.h>
-#else
-#include <string.h>
-#endif /* __KERNEL__ */
 
 #define AUTOFS_DEVICE_NAME		"autofs"
 

