Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab3D2TDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:03:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab3D2TDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>
Subject: [ 30/30] sparc32: support atomic64_t
Date: Mon, 29 Apr 2013 12:02:54 -0700
Message-Id: <20130429184358.679521952@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184355.299556377@linuxfoundation.org>
References: <20130429184355.299556377@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Ravnborg <sam@ravnborg.org>

commit aea1181b0bd0a09c54546399768f359d1e198e45 upstream, Needed to
compile ext4 for sparc32 since commit
503f4bdcc078e7abee273a85ce322de81b18a224

There is no-one that really require atomic64_t support on sparc32.
But several drivers fails to build without proper atomic64 support.
And for an allyesconfig build for sparc32 this is annoying.

Include the generic atomic64_t support for sparc32.
This has a text footprint cost:

$size vmlinux (before atomic64_t support)
   text    data     bss     dec     hex filename
3578860  134260  108781 3821901  3a514d vmlinux

$size vmlinux (after atomic64_t support)
   text    data     bss     dec     hex filename
3579892  130684  108781 3819357  3a475d vmlinux

text increase (3579892 - 3578860) = 1032 bytes

data decreases - but I fail to explain why!
I have rebuild twice to check my numbers.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/Kconfig                 |    1 +
 arch/sparc/include/asm/atomic_32.h |    2 ++
 2 files changed, 3 insertions(+)

--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -31,6 +31,7 @@ config SPARC
 
 config SPARC32
 	def_bool !64BIT
+	select GENERIC_ATOMIC64
 
 config SPARC64
 	def_bool 64BIT
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -15,6 +15,8 @@
 
 #ifdef __KERNEL__
 
+#include <asm-generic/atomic64.h>
+
 #include <asm/system.h>
 
 #define ATOMIC_INIT(i)  { (i) }


