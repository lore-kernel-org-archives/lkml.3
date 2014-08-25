Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaHYPdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:33:03 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:57999 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaHYPdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:33:01 -0400
Message-ID: <53FB572B.20401@bluespec.com>
Date: Mon, 25 Aug 2014 11:32:59 -0400
From: Darius Rad <darius@bluespec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] include/linux/types.h: avoid duplicate definition of atomic64_t
 when 64BIT && GENERIC_ATOMIC64
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_64BIT and CONFIG_GENERIC_ATOMIC64 are both y, atomic64_t is
defined in both include/linux/types.h and include/asm-generic/atomic64.h.
Allow the definition in include/asm-generic/atomic64.h to prevail, since
that definition is consistent with the rest of CONFIG_GENERIC_ATOMIC64.

Signed-off-by: Darius Rad <darius@bluespec.com>

---
It does not appear that this is relevant to architectures that are in the
kernel tree (i.e., no architectures use GENERIC_ATOMIC64 on 64-bit).  It
is relevant, however, to certain combinations of options for the RISC-V
architecture currently in development.

Patch generated against 3.17-rc1.

 include/linux/types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.17-rc1.orig/include/linux/types.h	2014-08-16 12:40:26.000000000 -0400
+++ linux-3.17-rc1/include/linux/types.h	2014-08-22 14:27:03.012782185 -0400
@@ -177,7 +177,7 @@ typedef struct {
 	int counter;
 } atomic_t;
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && !defined(CONFIG_GENERIC_ATOMIC64)
 typedef struct {
 	long counter;
 } atomic64_t;
