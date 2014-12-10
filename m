Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaLJNC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:02:56 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaLJNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:02:53 -0500
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, lftan@altera.com,
        arnd@arndb.de, geert@linux-m68k.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: Skip futex_atomic_cmpxchg_inatomic() test
Date: Wed, 10 Dec 2014 14:02:15 +0100
Message-Id: <1418216535-29295-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex_atomic_cmpxchg_inatomic() does not work on UML because
it triggers a copy_from_user() in kernel context.
On UML copy_from_user() can only be used if the kernel was called
by a real user space process such that UML can use ptrace()
to fetch the value.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.common | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 87bc868..d195a87 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -3,6 +3,7 @@ config UML
 	default y
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_UID16
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
-- 
2.1.0

