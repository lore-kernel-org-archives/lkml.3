Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaBZBJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:09:42 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48143 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaBZBJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:09:30 -0500
From: behanw@converseincode.com
To: mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, sparse@chrisli.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <mcharleb@gmail.com>
Subject: [PATCH 2/5] kbuild: LLVMLinux: Adapt warnings for compilation with clang
Date: Tue, 25 Feb 2014 17:08:40 -0800
Message-Id: <1393376923-21892-3-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

When compiling kernel with clang, disable warnings which are too noisy, and
add the clang flag catch-undefined-behavior.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <mcharleb@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
---
 scripts/Makefile.build | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5d859c..27c4098 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -65,12 +65,23 @@ warning-  := $(empty)
 warning-1 := -Wextra -Wunused -Wno-unused-parameter
 warning-1 += -Wmissing-declarations
 warning-1 += -Wmissing-format-attribute
-warning-1 += -Wmissing-prototypes
+warning-1 += $(call cc-option, -Wmissing-prototypes)
 warning-1 += -Wold-style-definition
 warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
 
+# Clang
+warning-1 += $(call cc-disable-warning, initializer-overrides)
+warning-1 += $(call cc-disable-warning, unused-value)
+warning-1 += $(call cc-disable-warning, format)
+warning-1 += $(call cc-disable-warning, unknown-warning-option)
+warning-1 += $(call cc-disable-warning, self-assign)
+warning-1 += $(call cc-disable-warning, sign-compare)
+warning-1 += $(call cc-disable-warning, format-zero-length)
+warning-1 += $(call cc-disable-warning, uninitialized)
+warning-1 += $(call cc-option, -fcatch-undefined-behavior)
+
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
 warning-2 += -Wdisabled-optimization
-- 
1.8.3.2

