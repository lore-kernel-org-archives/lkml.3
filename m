Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3GADOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 23:14:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55346 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab3GADOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 23:14:19 -0400
X-Sasl-enc: Rrakn2RxgfGlkGhDoaDt9zmYsf8dqExEWwTaEPWKf23Z 1372648458
Subject: [RFC PATCH 2/7] autofs4 - fix string.h include in auto_dev-ioctl.h
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2013 11:14:15 +0800
Message-ID: <20130701031414.4423.25878.stgit@perseus.fritz.box>
In-Reply-To: <20130701031335.4423.6154.stgit@perseus.fritz.box>
References: <20130701031335.4423.6154.stgit@perseus.fritz.box>
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
 

