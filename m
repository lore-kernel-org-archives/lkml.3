Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaJ1DuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:50:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbaJ1DuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:50:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.14 058/100] arm64: compat: fix compat types affecting struct compat_elf_prpsinfo
Date: Tue, 28 Oct 2014 11:35:43 +0800
Message-Id: <20141028033503.203814578@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/compat.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


