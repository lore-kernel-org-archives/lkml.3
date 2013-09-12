Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3ILR1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:27:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3ILR0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 18/19] m32r: make memset() global for CONFIG_KERNEL_BZIP2=y
Date: Thu, 12 Sep 2013 10:26:27 -0700
Message-Id: <20130912172526.130469489@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
References: <20130912172524.135620246@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m32r/boot/compressed/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m32r/boot/compressed/misc.c
+++ b/arch/m32r/boot/compressed/misc.c
@@ -28,7 +28,7 @@ static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
 
 #ifdef CONFIG_KERNEL_BZIP2
-static void *memset(void *s, int c, size_t n)
+void *memset(void *s, int c, size_t n)
 {
 	char *ss = s;
 


