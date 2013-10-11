Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab3JKKwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:52:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab3JKKny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kirill Tkhai <tkhai@yandex.ru>, David Miller <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 072/100] sparc64: Remove RWSEM export leftovers
Date: Fri, 11 Oct 2013 11:41:42 +0100
Message-Id: <1381488130-30235-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

commit 61d9b9355b0d427bd1e732bd54628ff9103e496f upstream.

The functions

			__down_read
			__down_read_trylock
			__down_write
			__down_write_trylock
			__up_read
			__up_write
			__downgrade_write

are implemented inline, so remove corresponding EXPORT_SYMBOLs
(They lead to compile errors on RT kernel).

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: David Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/lib/ksyms.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/sparc/lib/ksyms.c b/arch/sparc/lib/ksyms.c
index 3b31218..6a169df 100644
--- a/arch/sparc/lib/ksyms.c
+++ b/arch/sparc/lib/ksyms.c
@@ -98,15 +98,6 @@ EXPORT_SYMBOL(___copy_from_user);
 EXPORT_SYMBOL(___copy_in_user);
 EXPORT_SYMBOL(__clear_user);
 
-/* RW semaphores */
-EXPORT_SYMBOL(__down_read);
-EXPORT_SYMBOL(__down_read_trylock);
-EXPORT_SYMBOL(__down_write);
-EXPORT_SYMBOL(__down_write_trylock);
-EXPORT_SYMBOL(__up_read);
-EXPORT_SYMBOL(__up_write);
-EXPORT_SYMBOL(__downgrade_write);
-
 /* Atomic counter implementation. */
 EXPORT_SYMBOL(atomic_add);
 EXPORT_SYMBOL(atomic_add_ret);
-- 
1.8.3.2

