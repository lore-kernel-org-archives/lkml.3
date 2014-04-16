Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbaDPK4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:56:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51614 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbaDPKcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Finn Thain <fthain@telegraphics.com.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 05/46] m68k: Skip futex_atomic_cmpxchg_inatomic() test
Date: Wed, 16 Apr 2014 11:31:21 +0100
Message-Id: <1397644322-13905-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@telegraphics.com.au>

commit e571c58f313d35c56e0018470e3375ddd1fd320e upstream.

Skip the futex_atomic_cmpxchg_inatomic() test in futex_init(). It causes a
fatal exception on 68030 (and presumably 68020 also).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1403061006440.5525@nippy.intranet
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/m68k/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 821170e..b969eea 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -16,6 +16,7 @@ config M68K
 	select FPU if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
+	select HAVE_FUTEX_CMPXCHG if MMU && FUTEX
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
-- 
1.9.1

