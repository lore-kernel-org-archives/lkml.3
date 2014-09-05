Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaIEXgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:36:54 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36792 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaIEXgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:36:53 -0400
From: behanw@converseincode.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] fs, LLVMLinux: Remove warning from COMPATIBLE_IOCTL
Date: Fri,  5 Sep 2014 16:36:39 -0700
Message-Id: <1409960199-29331-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

cmd in COMPATIBLE_IOCTL is always a u32, so cast it so there isn't a warning
about an overflow in XFORM.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 fs/compat_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index afec645..f6ce1aa 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -810,7 +810,7 @@ static int compat_ioctl_preallocate(struct file *file,
  */
 #define XFORM(i) (((i) ^ ((i) << 27) ^ ((i) << 17)) & 0xffffffff)
 
-#define COMPATIBLE_IOCTL(cmd) XFORM(cmd),
+#define COMPATIBLE_IOCTL(cmd) XFORM((u32)cmd),
 /* ioctl should not be warned about even if it's not implemented.
    Valid reasons to use this:
    - It is implemented with ->compat_ioctl on some device, but programs
-- 
1.9.1

