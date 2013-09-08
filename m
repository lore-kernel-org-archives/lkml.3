Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab3IHDTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56111 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755583Ab3IHDSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Sam Ravnborg" <sam@ravnborg.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.81950593@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [097/121] sparc32: support atomic64_t
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Ravnborg <sam@ravnborg.org>

commit aea1181b0bd0a09c54546399768f359d1e198e45 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/Kconfig                 | 1 +
 arch/sparc/include/asm/atomic_32.h | 2 ++
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

