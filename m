Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaAVDCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:02:04 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48040 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbaAVDBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:01:54 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] uapi: ppp-ioctl.h: pull in ppp_defs.h
Date: Tue, 21 Jan 2014 22:01:49 -0500
Message-Id: <1390359709-11744-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header uses enum NPmode but doesn't include ppp_defs.h.  If you try
to use this header w/out including the defs header first, it leads to a
build failure.  So add the explicit include to fix it.

Don't know of any packages directly impacted, but noticed while building
some ppp code by hand.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/uapi/linux/ppp-ioctl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
index 2d9a885..63a23a3 100644
--- a/include/uapi/linux/ppp-ioctl.h
+++ b/include/uapi/linux/ppp-ioctl.h
@@ -12,6 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/ppp_defs.h>
 
 /*
  * Bit definitions for flags argument to PPPIOCGFLAGS/PPPIOCSFLAGS.
-- 
1.8.4.3

