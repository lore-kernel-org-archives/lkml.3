Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbbA2KWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:22:21 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756380AbbA2JAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:51 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 127/176] um: Skip futex_atomic_cmpxchg_inatomic() test
Date: Wed, 28 Jan 2015 15:29:17 +0100
Message-Id: <8f8c6ea486fc69e3020fe99718d9c4b38cbaf8ba.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f911d731054ab3d82ee72a16b889e17ca3a2332a upstream.

futex_atomic_cmpxchg_inatomic() does not work on UML because
it triggers a copy_from_user() in kernel context.
On UML copy_from_user() can only be used if the kernel was called
by a real user space process such that UML can use ptrace()
to fetch the value.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Tested-by: Daniel Walter <d.walter@0x90.at>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/um/Kconfig.common | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 8ddea1f8006a..0228a6ab9b18 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -7,6 +7,7 @@ config UML
 	bool
 	default y
 	select HAVE_UID16
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
-- 
2.2.2

