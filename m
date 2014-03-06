Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaCFSDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:03:13 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:40574 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaCFSDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:03:11 -0500
From: behanw@converseincode.com
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, pageexec@freemail.hu,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH 5/5 v2] x86 kbuild: LLVMLinux: More cc-options added for clang
Date: Thu,  6 Mar 2014 10:03:06 -0800
Message-Id: <1394128986-3915-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <530D4445.8060304@zytor.com>
References: <530D4445.8060304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Protect more options for x86 with cc-option so that we don't get errors when
using clang instead of gcc.  Add more or different options when using clang as
well. Also need to enforce that SSE is off for clang and the stack is 8-byte
aligned.

Removed improper reassetion of -mno-sse and -mpreferred-stack-boundary

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eeda43a..d5a5a91 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -108,7 +108,7 @@ else
 
         # this works around some issues with generating unwind tables in older gccs
         # newer gccs do it by default
-        KBUILD_CFLAGS += -maccumulate-outgoing-args
+        KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args)
 endif
 
 # Make sure compiler does not have buggy stack-protector support.
-- 
1.8.3.2

