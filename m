Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbaIOWKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:10:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50440 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbaIOWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 013/187] sparc64: Fix argument sign extension for compat_sys_futex().
Date: Mon, 15 Sep 2014 15:07:03 -0700
Message-Id: <1410818997-9432-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit aa3449ee9c87d9b7660dd1493248abcc57769e31 ]

Only the second argument, 'op', is signed.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/sys32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/sys32.S b/arch/sparc/kernel/sys32.S
index f7c72b6..d066eb1 100644
--- a/arch/sparc/kernel/sys32.S
+++ b/arch/sparc/kernel/sys32.S
@@ -44,7 +44,7 @@ SIGN1(sys32_timer_settime, compat_sys_timer_settime, %o1)
 SIGN1(sys32_io_submit, compat_sys_io_submit, %o1)
 SIGN1(sys32_mq_open, compat_sys_mq_open, %o1)
 SIGN1(sys32_select, compat_sys_select, %o0)
-SIGN3(sys32_futex, compat_sys_futex, %o1, %o2, %o5)
+SIGN1(sys32_futex, compat_sys_futex, %o1)
 SIGN1(sys32_recvfrom, compat_sys_recvfrom, %o0)
 SIGN1(sys32_recvmsg, compat_sys_recvmsg, %o0)
 SIGN1(sys32_sendmsg, compat_sys_sendmsg, %o0)
-- 
1.9.1

