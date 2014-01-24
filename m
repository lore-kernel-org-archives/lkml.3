Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaAXQlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:41:32 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34310 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaAXQl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:41:28 -0500
From: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Michel Dagenais <michel.dagenais@polymtl.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 4/6] ARM: Make PID_IN_CONTEXTIDR incompatible with PID_NS
Date: Fri, 24 Jan 2014 11:40:54 -0500
Message-Id: <1390581656-16372-5-git-send-email-adrienverge@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
References: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using namespaces, different processes can have the same PID.
It makes no sense to store a PID value in the Context ID register
to track a specific process, when others share the same value.

Consequently, PID_IN_CONTEXTIDR (which is used for tracing and
debugging processes) should not be compatible with PID_NS.

Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
---
 arch/arm/Kconfig.debug   | 2 +-
 arch/arm64/Kconfig.debug | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5765abf..ed46748 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1143,7 +1143,7 @@ config ARM_KPROBES_TEST
 
 config PID_IN_CONTEXTIDR
 	bool "Write the current PID to the CONTEXTIDR register"
-	depends on CPU_COPY_V6
+	depends on CPU_COPY_V6 && !PID_NS
 	help
 	  Enabling this option causes the kernel to write the current PID to
 	  the PROCID field of the CONTEXTIDR register, at the expense of some
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 835c559..06b2633b 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -17,6 +17,7 @@ config EARLY_PRINTK
 
 config PID_IN_CONTEXTIDR
 	bool "Write the current PID to the CONTEXTIDR register"
+	depends on !PID_NS
 	help
 	  Enabling this option causes the kernel to write the current PID to
 	  the CONTEXTIDR register, at the expense of some additional
-- 
1.8.5.2

