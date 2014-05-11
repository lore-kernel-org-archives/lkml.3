Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbaEKT0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:26:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933931AbaEKT0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        George Spelvin <linux@horizon.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.14 83/83] x86-64, build: Fix stack protector Makefile breakage with 32-bit userland
Date: Sun, 11 May 2014 21:20:24 +0200
Message-Id: <20140511191917.766931499@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Spelvin <linux@horizon.com>

commit 14262d67fe348018af368a07430fbc06eadeabb1 upstream.

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
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -79,6 +79,7 @@ else
         UTS_MACHINE := x86_64
         CHECKFLAGS += -D__x86_64__ -m64
 
+        biarch := -m64
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 


