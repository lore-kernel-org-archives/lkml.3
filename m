Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaAGOWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:22:15 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58766 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaAGOWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:22:03 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v8 5/7] arm64, jump label: detect %c support for ARM64
Date: Tue,  7 Jan 2014 22:17:12 +0800
Message-Id: <1389104234-15239-6-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389104234-15239-1-git-send-email-liuj97@gmail.com>
References: <1389104234-15239-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As commit a9468f30b5eac6 "ARM: 7333/2: jump label: detect %c
support for ARM", this patch detects the same thing for ARM64
because some ARM64 GCC versions have the same issue.

Some versions of ARM64 GCC which do support asm goto, do not
support the %c specifier. Since we need the %c to support jump
labels on ARM64, detect that too in the asm goto detection script
to avoid build errors with these versions.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 scripts/gcc-goto.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
index a2af2e8..c9469d3 100644
--- a/scripts/gcc-goto.sh
+++ b/scripts/gcc-goto.sh
@@ -5,7 +5,7 @@
 cat << "END" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
 int main(void)
 {
-#ifdef __arm__
+#if defined(__arm__) || defined(__aarch64__)
 	/*
 	 * Not related to asm goto, but used by jump label
 	 * and broken on some ARM GCC versions (see GCC Bug 48637).
-- 
1.8.1.2

