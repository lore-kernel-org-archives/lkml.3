Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3J2M6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:58:18 -0400
Received: from hall.aurel32.net ([195.154.112.97]:34242 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab3J2M6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:58:17 -0400
X-Greylist: delayed 1742 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2013 08:58:16 EDT
From: Aurelien Jarno <aurelien@aurel32.net>
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Aurelien Jarno <aurelien@aurel32.net>
Subject: [PATCH] UAPI: include <asm/byteorder.h> in linux/raid/md_p.h
Date: Tue, 29 Oct 2013 13:28:58 +0100
Message-Id: <1383049738-26107-1-git-send-email-aurelien@aurel32.net>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/raid/md_p.h is using conditionals depending on endianess and fails
with an error if neither of __BIG_ENDIAN, __LITTLE_ENDIAN or
__BYTE_ORDER are defined, but it doesn't include any header which can
define these constants. This make this header unusable alone.

This patch adds a #include <asm/byteorder.h> at the beginning of this
header to make it usable alone. This is needed to compile klibc on MIPS.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 include/uapi/linux/raid/md_p.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index fe1a540..f7cf7f3 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -16,6 +16,7 @@
 #define _MD_P_H
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 /*
  * RAID superblock.
-- 
1.8.3.1

