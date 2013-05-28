Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab3E1NfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:35:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937Ab3E1NfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:35:11 -0400
Date: Tue, 28 May 2013 06:34:45 -0700
From: tip-bot for Zhang Yanfei <tipbot@zytor.com>
Message-ID: <tip-1e3b308181c435675d21e37a683d51519ba37dc5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zhangyanfei@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, tglx@linutronix.de
In-Reply-To: <5192F9BF.2000802@cn.fujitsu.com>
References: <5192F9BF.2000802@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86_64: Correct phys_addr in cleanup_highmap comment
Git-Commit-ID: 1e3b308181c435675d21e37a683d51519ba37dc5
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

Commit-ID:  1e3b308181c435675d21e37a683d51519ba37dc5
Gitweb:     http://git.kernel.org/tip/1e3b308181c435675d21e37a683d51519ba37dc5
Author:     Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
AuthorDate: Wed, 15 May 2013 10:58:07 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 11:41:24 +0200

x86_64: Correct phys_addr in cleanup_highmap comment

For x86_64, we have phys_base, which means the delta between the
the address kernel is actually running at and the address kernel
is compiled to run at. Not phys_addr so correct it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/5192F9BF.2000802@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/init_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bb00c46..b3940b6 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -368,7 +368,7 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
  *
  *   from __START_KERNEL_map to __START_KERNEL_map + size (== _end-_text)
  *
- * phys_addr holds the negative offset to the kernel, which is added
+ * phys_base holds the negative offset to the kernel, which is added
  * to the compile time generated pmds. This results in invalid pmds up
  * to the point where we hit the physaddr 0 mapping.
  *
