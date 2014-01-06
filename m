Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbaAFWmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:42:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094AbaAFWl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Feng Kan <fkan@apm.com>, Kumar Sankaran <ksankaran@apm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 121/129] arm64: Change kernel stack size to 16K
Date: Mon,  6 Jan 2014 14:39:10 -0800
Message-Id: <20140106223903.055447281@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Kan <fkan@apm.com>

commit 845ad05ec31e0f3872a321e10dbeaf872022632c upstream.

Written by Catalin Marinas, tested by APM on storm platform. This is needed
because of the failures encountered when running SpecWeb benchmark test.

Signed-off-by: Feng Kan <fkan@apm.com>
Acked-by: Kumar Sankaran <ksankaran@apm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/thread_info.h |    4 ++--
 arch/arm64/kernel/entry.S            |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -24,10 +24,10 @@
 #include <linux/compiler.h>
 
 #ifndef CONFIG_ARM64_64K_PAGES
-#define THREAD_SIZE_ORDER	1
+#define THREAD_SIZE_ORDER	2
 #endif
 
-#define THREAD_SIZE		8192
+#define THREAD_SIZE		16384
 #define THREAD_START_SP		(THREAD_SIZE - 16)
 
 #ifndef __ASSEMBLY__
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -121,7 +121,7 @@
 
 	.macro	get_thread_info, rd
 	mov	\rd, sp
-	and	\rd, \rd, #~((1 << 13) - 1)	// top of 8K stack
+	and	\rd, \rd, #~(THREAD_SIZE - 1)	// top of stack
 	.endm
 
 /*


