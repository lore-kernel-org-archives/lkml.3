Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab3CLNBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:01:18 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:48006 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab3CLNBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:01:16 -0400
From: Zhi-zhou Zhang <zhizhou.zh@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Zhi-zhou Zhang <zhizhou.zh@gmail.com>
Subject: [PATCH] mips: lib/bitops.c: fix wrong return type
Date: Tue, 12 Mar 2013 21:00:53 +0800
Message-Id: <1363093253-17595-1-git-send-email-zhizhou.zh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here should return 64-bit types rather than 32-bit types. Or we
may get wrong return value if high 32-bit isn't equal to zero.

Signed-off-by: Zhi-zhou Zhang <zhizhou.zh@gmail.com>
---
 arch/mips/include/asm/bitops.h |    8 ++++----
 arch/mips/lib/bitops.c         |   10 ++++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/bitops.h b/arch/mips/include/asm/bitops.h
index 71305a8..7502601 100644
--- a/arch/mips/include/asm/bitops.h
+++ b/arch/mips/include/asm/bitops.h
@@ -51,13 +51,13 @@
 void __mips_set_bit(unsigned long nr, volatile unsigned long *addr);
 void __mips_clear_bit(unsigned long nr, volatile unsigned long *addr);
 void __mips_change_bit(unsigned long nr, volatile unsigned long *addr);
-int __mips_test_and_set_bit(unsigned long nr,
+unsigned long __mips_test_and_set_bit(unsigned long nr,
 			    volatile unsigned long *addr);
-int __mips_test_and_set_bit_lock(unsigned long nr,
+unsigned long __mips_test_and_set_bit_lock(unsigned long nr,
 				 volatile unsigned long *addr);
-int __mips_test_and_clear_bit(unsigned long nr,
+unsigned long __mips_test_and_clear_bit(unsigned long nr,
 			      volatile unsigned long *addr);
-int __mips_test_and_change_bit(unsigned long nr,
+unsigned long __mips_test_and_change_bit(unsigned long nr,
 			       volatile unsigned long *addr);
 
 
diff --git a/arch/mips/lib/bitops.c b/arch/mips/lib/bitops.c
index 81f1dcf..f8d14fc 100644
--- a/arch/mips/lib/bitops.c
+++ b/arch/mips/lib/bitops.c
@@ -83,7 +83,7 @@ EXPORT_SYMBOL(__mips_change_bit);
  * @nr: Bit to set
  * @addr: Address to count from
  */
-int __mips_test_and_set_bit(unsigned long nr,
+unsigned long __mips_test_and_set_bit(unsigned long nr,
 			    volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr;
@@ -109,7 +109,7 @@ EXPORT_SYMBOL(__mips_test_and_set_bit);
  * @nr: Bit to set
  * @addr: Address to count from
  */
-int __mips_test_and_set_bit_lock(unsigned long nr,
+unsigned long __mips_test_and_set_bit_lock(unsigned long nr,
 				 volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr;
@@ -135,7 +135,8 @@ EXPORT_SYMBOL(__mips_test_and_set_bit_lock);
  * @nr: Bit to clear
  * @addr: Address to count from
  */
-int __mips_test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
+unsigned long __mips_test_and_clear_bit(unsigned long nr,
+				volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr;
 	unsigned bit = nr & SZLONG_MASK;
@@ -160,7 +161,8 @@ EXPORT_SYMBOL(__mips_test_and_clear_bit);
  * @nr: Bit to change
  * @addr: Address to count from
  */
-int __mips_test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
+unsigned long __mips_test_and_change_bit(unsigned long nr,
+				volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr;
 	unsigned bit = nr & SZLONG_MASK;
-- 
1.7.9.5

