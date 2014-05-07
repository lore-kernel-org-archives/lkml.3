Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaEGVtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:49:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaEGVtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:49:05 -0400
Date: Wed, 7 May 2014 14:48:31 -0700
From: tip-bot for George Spelvin <tipbot@zytor.com>
Message-ID: <tip-14262d67fe348018af368a07430fbc06eadeabb1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux@horizon.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux@horizon.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20140507210552.7581.qmail@ns.horizon.com>
References: <20140507210552.7581.qmail@ns.horizon.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64, build:
  Fix stack protector Makefile breakage with 32-bit userland
Git-Commit-ID: 14262d67fe348018af368a07430fbc06eadeabb1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14262d67fe348018af368a07430fbc06eadeabb1
Gitweb:     http://git.kernel.org/tip/14262d67fe348018af368a07430fbc06eadeabb1
Author:     George Spelvin <linux@horizon.com>
AuthorDate: Wed, 7 May 2014 17:05:52 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 7 May 2014 14:14:44 -0700

x86-64, build: Fix stack protector Makefile breakage with 32-bit userland

If you are using a 64-bit kernel with 32-bit userland, then
scripts/gcc-x86_64-has-stack-protector.sh invokes 32-bit gcc
with -mcmodel=kernel, which produces:

<stdin>:1:0: error: code model 'kernel' not supported in the 32 bit mode

and trips the "broken compiler" test at arch/x86/Makefile:120.

There are several places a fix is possible, but the following seems
cleanest.  (But it's minimal; it would also be possible to factor
out a bunch of stuff from the two branches of the if.)

Signed-off-by: George Spelvin <linux@horizon.com>
Link: http://lkml.kernel.org/r/20140507210552.7581.qmail@ns.horizon.com
Cc: <stable@vger.kernel.org> # v3.14
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index ce6ad7e..33f71b0 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -79,6 +79,7 @@ else
         UTS_MACHINE := x86_64
         CHECKFLAGS += -D__x86_64__ -m64
 
+        biarch := -m64
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
