Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaKBUPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:15:30 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:33532 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbaKBUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:15:28 -0500
Message-ID: <545690D0.5040904@ladisch.de>
Date: Sun, 02 Nov 2014 21:15:12 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sparc64: Add preprocessor symbols for PAGE_* pgprot_t values.
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20141102201409.317970.89625@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel code assumes that the PAGE_* values are preprocessor symbols, and
that therefore arch support can be checked for with #ifdef.

At the moment, sparc64 does not implement any of the symbols checked
for, so these checks happen to work.

To prevent potential breakage when another #ifdef check is added or when
sparc64 implements another PAGE_ value, make such #ifdef checks work by
adding preprocessor symbols on top of the PAGE_* variables.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 arch/sparc/include/asm/pgtable_64.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index bfeb626..a835fe9 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -216,9 +216,13 @@ pte_t mk_pte_io(unsigned long, pgprot_t, int, unsigned long);
 unsigned long pte_sz_bits(unsigned long size);

 extern pgprot_t PAGE_KERNEL;
+#define PAGE_KERNEL		PAGE_KERNEL
 extern pgprot_t PAGE_KERNEL_LOCKED;
+#define PAGE_KERNEL_LOCKED	PAGE_KERNEL_LOCKED
 extern pgprot_t PAGE_COPY;
+#define PAGE_COPY		PAGE_COPY
 extern pgprot_t PAGE_SHARED;
+#define PAGE_SHARED		PAGE_SHARED

 /* XXX This uglyness is for the atyfb driver's sparc mmap() support. XXX */
 extern unsigned long _PAGE_IE;
