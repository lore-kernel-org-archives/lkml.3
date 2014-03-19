Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbaCSKn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:43:28 -0400
Received: from ns.horizon.com ([71.41.210.147]:65215 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757750AbaCSKn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:43:27 -0400
Date: 19 Mar 2014 06:43:23 -0400
Message-ID: <20140319104323.517.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: arjan@linux.intel.com, tj@kernel.org, x86@kernel.org
Subject: [PATCH] Stack protector Makefile breakage on x86_64
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are using a 64-bit kernel with 32-bit userland, then
scripts/gcc-x86_64-has-stack-protector.sh invokes -32-bit gcc
with -mcmodel=kernel, which produces:

<stdin>:1:0: error: code model 'kernel' not supported in the 32 bit mode

and trips the "broken compiler" test at arch/x86/Makefile:118.

There are several places a fix is possible, but the following seems
cleanest.  (But it's minimal; it would also be possible to factor
out a bunch of stuff from the two btanches of the if.)

Signed-off-by: George Spelvin <linux@horizon.com>

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eeda43abed..c6c61361c3 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -79,6 +79,7 @@ else
         UTS_MACHINE := x86_64
         CHECKFLAGS += -D__x86_64__ -m64
 
+        biarch := -m64
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
