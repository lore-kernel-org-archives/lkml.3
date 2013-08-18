Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3HRU2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:28:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3HRU2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:28:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 08/12] sparc32: Add ucmpdi2.o to obj-y instead of lib-y.
Date: Sun, 18 Aug 2013 13:30:17 -0700
Message-Id: <20130818202951.495800621@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818202949.875887601@linuxfoundation.org>
References: <20130818202949.875887601@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 74c7b28953d4eaa6a479c187aeafcfc0280da5e8 upstream.

Otherwise if no references exist in the static kernel image,
we won't export the symbol properly to modules.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -15,7 +15,7 @@ lib-$(CONFIG_SPARC32) += divdi3.o udivdi
 lib-$(CONFIG_SPARC32) += copy_user.o locks.o
 lib-y                 += atomic_$(BITS).o
 lib-$(CONFIG_SPARC32) += lshrdi3.o ashldi3.o
-lib-$(CONFIG_SPARC32) += muldi3.o bitext.o cmpdi2.o ucmpdi2.o
+lib-$(CONFIG_SPARC32) += muldi3.o bitext.o cmpdi2.o
 
 lib-$(CONFIG_SPARC64) += copy_page.o clear_page.o bzero.o
 lib-$(CONFIG_SPARC64) += csum_copy.o csum_copy_from_user.o csum_copy_to_user.o
@@ -40,7 +40,7 @@ lib-$(CONFIG_SPARC64) += copy_in_user.o
 lib-$(CONFIG_SPARC64) += mcount.o ipcsum.o xor.o hweight.o ffs.o
 
 obj-y                 += iomap.o
-obj-$(CONFIG_SPARC32) += atomic32.o
+obj-$(CONFIG_SPARC32) += atomic32.o ucmpdi2.o
 obj-y                 += ksyms.o
 obj-$(CONFIG_SPARC64) += PeeCeeI.o
 obj-y                 += usercopy.o


