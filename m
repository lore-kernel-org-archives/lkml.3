Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaBINeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:34:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56193 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaBINeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:34:01 -0500
Date: Sun, 9 Feb 2014 19:03:54 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>, josh@joshtriplett.org
Subject: [PATCH 21/21] fs: Move prototype declaration to appropriate header
 file
Message-ID: <94bd5f839212612524d7b8dc2d6a6d4ed96b42da.1391952682.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <764a2eddc09cb8670d757cd4170d44d41b3971e0.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration to header file include/linux/crash_dump.h
because it is used by more than file.

This eliminates the following warning in proc/vmcore.c:
fs/proc/vmcore.c:1088:6: warning: no previous prototype for ‘vmcore_cleanup’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/crash_dump.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 7032518..72ab536 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -25,6 +25,7 @@ extern int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
+void vmcore_cleanup(void);
 
 /* Architecture code defines this if there are other possible ELF
  * machine types, e.g. on bi-arch capable hardware. */
-- 
1.7.9.5

