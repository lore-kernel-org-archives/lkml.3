Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaLDPqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:46:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbaLDPqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:46:34 -0500
From: Alexander Graf <agraf@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
Date: Thu,  4 Dec 2014 16:46:33 +0100
Message-Id: <1417707993-82290-1-git-send-email-agraf@suse.de>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With binutils 2.25 the default alignment for 32bit arm sections changed to
have everything 64k aligned. Armv7 binaries built with this binutils version
run successfully on an arm64 system.

Since effectively there is now the chance to run armv7 code on arm64 even
with 64k page size, it doesn't make sense to block people from enabling
CONFIG_COMPAT on those configurations.

Signed-off-by: Alexander Graf <agraf@suse.de>
---
 arch/arm64/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9532f8d..3cf4f238 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -409,7 +409,6 @@ source "fs/Kconfig.binfmt"
 
 config COMPAT
 	bool "Kernel support for 32-bit EL0"
-	depends on !ARM64_64K_PAGES
 	select COMPAT_BINFMT_ELF
 	select HAVE_UID16
 	select OLD_SIGSUSPEND3
-- 
1.7.12.4

