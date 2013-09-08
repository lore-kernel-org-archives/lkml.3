Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab3IHDVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56243 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836Ab3IHDS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Guenter Roeck" <linux@roeck-us.net>,
        "Will Deacon" <will.deacon@arm.com>,
        "Michael Cree" <mcree@orcon.net.nz>,
        "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
        "Matt Turner" <mattst88@gmail.com>,
        "Richard Henderson" <rth@twiddle.net>,
        "Thorsten Kranzkowski" <dl8bcu@dl8bcu.de>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.450384565@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [095/121] alpha: makefile: don't enforce small data model for 
 kernel builds
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit cd8d2331756751b6aeb855a3c9cb0a92fbd9c725 upstream.

Due to all of the goodness being packed into today's kernels, the
resulting image isn't as slim as it once was.

In light of this, don't pass -msmall-data to gcc, which otherwise results
in link failures due to impossible relocations when compiling anything but
the most trivial configurations.

Reviewed-by: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Tested-by: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/alpha/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/alpha/Makefile
+++ b/arch/alpha/Makefile
@@ -12,7 +12,7 @@ NM := $(NM) -B
 
 LDFLAGS_vmlinux	:= -static -N #-relax
 CHECKFLAGS	+= -D__alpha__ -m64
-cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
+cflags-y	:= -pipe -mno-fp-regs -ffixed-8
 cflags-y	+= $(call cc-option, -fno-jump-tables)
 
 cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4

