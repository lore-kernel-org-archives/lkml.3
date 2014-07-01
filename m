Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaGAAnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:43:01 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64975 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaGAAm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:42:59 -0400
From: behanw@converseincode.com
To: mmarek@suse.cz, bp@alien8.de
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, dl9pf@gmx.de,
        pageexec@freemail.hu, mcharleb@gmail.com,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] kbuild, LLVMLinux: only use warnings when using clang
Date: Mon, 30 Jun 2014 17:42:26 -0700
Message-Id: <1404175346-12330-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140629201308.GC12943@pd.tnic>
References: <20140629201308.GC12943@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Only consider clang warnings in Kbuild when using the clang compiler.

Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 scripts/Makefile.extrawarn | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 6564350..e350127 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -26,7 +26,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
 
-# Clang
+ifeq ($(COMPILER),clang)
 warning-1 += $(call cc-disable-warning, initializer-overrides)
 warning-1 += $(call cc-disable-warning, unused-value)
 warning-1 += $(call cc-disable-warning, format)
@@ -35,6 +35,7 @@ warning-1 += $(call cc-disable-warning, sign-compare)
 warning-1 += $(call cc-disable-warning, format-zero-length)
 warning-1 += $(call cc-disable-warning, uninitialized)
 warning-1 += $(call cc-option, -fcatch-undefined-behavior)
+endif
 
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
-- 
1.9.1

