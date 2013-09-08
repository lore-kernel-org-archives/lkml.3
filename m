Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab3IHDpF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:45:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56225 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757079Ab3IHDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Hirokazu Takata" <takata@linux-m32r.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.886410986@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [114/121] m32r: make memset() global for CONFIG_KERNEL_BZIP2=y
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 9a75c6e5240f7edc5955e8da5b94bde6f96070b3 upstream.

Fix the m32r compile error:

  arch/m32r/boot/compressed/misc.c:31:14: error: static declaration of 'memset' follows non-static declaration
  make[5]: *** [arch/m32r/boot/compressed/misc.o] Error 1
  make[4]: *** [arch/m32r/boot/compressed/vmlinux] Error 2

by removing the static keyword.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m32r/boot/compressed/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m32r/boot/compressed/misc.c b/arch/m32r/boot/compressed/misc.c
index 3147aa2..28a0952 100644
--- a/arch/m32r/boot/compressed/misc.c
+++ b/arch/m32r/boot/compressed/misc.c
@@ -28,7 +28,7 @@ static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
 
 #ifdef CONFIG_KERNEL_BZIP2
-static void *memset(void *s, int c, size_t n)
+void *memset(void *s, int c, size_t n)
 {
 	char *ss = s;
 

