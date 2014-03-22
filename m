Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbaCVGjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:39:01 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35898 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaCVGi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:38:57 -0400
From: behanw@converseincode.com
To: arnd@arndb.de
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH] LLVMLinux: Remove warning about returning an uninitialized variable
Date: Fri, 21 Mar 2014 23:38:49 -0700
Message-Id: <1395470329-15065-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Fix uninitialized return code in default case in cmpxchg-local.h

This patch fixes the code to prevent an uninitialized return value that is detected
when compiling with clang. The bug produces numerous warnings when compiling the
Linux kernel with clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
---
 include/asm-generic/cmpxchg-local.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
index d8d4c89..4c41bb8 100644
--- a/include/asm-generic/cmpxchg-local.h
+++ b/include/asm-generic/cmpxchg-local.h
@@ -41,6 +41,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
 		break;
 	default:
 		wrong_size_cmpxchg(ptr);
+		prev = 0;
 	}
 	raw_local_irq_restore(flags);
 	return prev;
-- 
1.8.3.2

