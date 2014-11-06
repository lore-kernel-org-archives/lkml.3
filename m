Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaKFWn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:43:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59059 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaKFWn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Victor Kamensky <victor.kamensky@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 083/162] arm64: compat: fix compat types affecting struct compat_elf_prpsinfo
Date: Thu,  6 Nov 2014 14:35:47 -0800
Message-Id: <1415313426-9622-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Kamensky <victor.kamensky@linaro.org>

commit 971a5b6fe634bb7b617d8c5f25b6a3ddbc600194 upstream.

The compat_elf_prpsinfo structure does not match the arch/arm struct
elf_pspsinfo definition. As result NT_PRPSINFO note in core file
created by arm64 kernel for aarch32 (compat) process has wrong size.
So gdb cannot display command that caused process crash.

Fix is to change size of __compat_uid_t, __compat_gid_t so it would
match size of similar fields in arch/arm case.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/include/asm/compat.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index fda2704..e72289a 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -37,8 +37,8 @@ typedef s32		compat_ssize_t;
 typedef s32		compat_time_t;
 typedef s32		compat_clock_t;
 typedef s32		compat_pid_t;
-typedef u32		__compat_uid_t;
-typedef u32		__compat_gid_t;
+typedef u16		__compat_uid_t;
+typedef u16		__compat_gid_t;
 typedef u16		__compat_uid16_t;
 typedef u16		__compat_gid16_t;
 typedef u32		__compat_uid32_t;
-- 
1.9.1

