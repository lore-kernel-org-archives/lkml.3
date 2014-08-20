Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaHTMEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:04:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58920 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 043/104] sparc64: Fix argument sign extension for compat_sys_futex().
Date: Wed, 20 Aug 2014 13:43:06 +0200
Message-Id: <b87c3db222bba76dfc08d6ce65d9c73c8f1df00c.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit aa3449ee9c87d9b7660dd1493248abcc57769e31 ]

Only the second argument, 'op', is signed.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/kernel/sys32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/sys32.S b/arch/sparc/kernel/sys32.S
index f7c72b6efc27..d066eb18650c 100644
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
2.0.4

