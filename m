Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3J2SIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:08:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59410 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3J2SIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kirill Tkhai <tkhai@yandex.ru>, David Miller <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 60/81] sparc64: Remove RWSEM export leftovers
Date: Tue, 29 Oct 2013 11:04:21 -0700
Message-Id: <1383069882-11437-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

[ Upstream commit 61d9b9355b0d427bd1e732bd54628ff9103e496f ]

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/lib/ksyms.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/sparc/lib/ksyms.c b/arch/sparc/lib/ksyms.c
index 0c4e35e..323335b 100644
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
1.8.1.2

