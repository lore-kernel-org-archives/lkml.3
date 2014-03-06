Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaCFKiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:38:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaCFKh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:37:57 -0500
Date: Thu, 6 Mar 2014 02:37:32 -0800
From: tip-bot for Finn Thain <tipbot@zytor.com>
Message-ID: <tip-e571c58f313d35c56e0018470e3375ddd1fd320e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        geert@linux-m68k.org, fthain@telegraphics.com.au, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, fthain@telegraphics.com.au, tglx@linutronix.de
In-Reply-To: <alpine.LNX.2.00.1403061006440.5525@nippy.intranet>
References: <alpine.LNX.2.00.1403061006440.5525@nippy.intranet>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] m68k: Skip futex_atomic_cmpxchg_inatomic()
  test
Git-Commit-ID: e571c58f313d35c56e0018470e3375ddd1fd320e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e571c58f313d35c56e0018470e3375ddd1fd320e
Gitweb:     http://git.kernel.org/tip/e571c58f313d35c56e0018470e3375ddd1fd320e
Author:     Finn Thain <fthain@telegraphics.com.au>
AuthorDate: Thu, 6 Mar 2014 10:29:27 +1100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 6 Mar 2014 11:35:17 +0100

m68k: Skip futex_atomic_cmpxchg_inatomic() test

Skip the futex_atomic_cmpxchg_inatomic() test in futex_init(). It causes a 
fatal exception on 68030 (and presumably 68020 also).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1403061006440.5525@nippy.intranet
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/m68k/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index dbdd223..b2e3229 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -17,6 +17,7 @@ config M68K
 	select FPU if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
+	select HAVE_FUTEX_CMPXCHG if MMU && FUTEX
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
