Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbaFQREe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:04:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50324 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364AbaFQQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 005/121] parisc: fix epoll_pwait syscall on compat kernel
Date: Tue, 17 Jun 2014 09:13:18 -0700
Message-Id: <1403021714-16320-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit ab3e55b119c9653b19ea4edffb86f04db867ac98 upstream.

This bug was detected with the libio-epoll-perl debian package where the
test case IO-Ppoll-compat.t failed.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/parisc/kernel/syscall_table.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscall_table.S
index 54d950b..ea4ec1e 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -395,7 +395,7 @@
 	ENTRY_COMP(vmsplice)
 	ENTRY_COMP(move_pages)		/* 295 */
 	ENTRY_SAME(getcpu)
-	ENTRY_SAME(epoll_pwait)
+	ENTRY_COMP(epoll_pwait)
 	ENTRY_COMP(statfs64)
 	ENTRY_COMP(fstatfs64)
 	ENTRY_COMP(kexec_load)		/* 300 */
-- 
1.9.1

