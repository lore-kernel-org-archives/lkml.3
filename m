Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3KKNlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:41:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab3KKNlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:41:03 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Joe Mario <jmario@redhat.com>
Subject: [PATCH 2/2] kallsyms: Revert back to 128 max symbol length
Date: Mon, 11 Nov 2013 14:40:36 +0100
Message-Id: <1384177236-8371-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384177236-8371-1-git-send-email-mmarek@suse.cz>
References: <1384177236-8371-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commits
f3462aa (Kbuild: Handle longer symbols in kallsyms.c) and
eea0e9c (kbuild: Increase kallsyms max symbol length)
except for the added overflow check. The reason is a regression caused
by increasing the buffer:
http://marc.info/?l=linux-kernel&m=138387700415675.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Joe Mario <jmario@redhat.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 include/linux/kallsyms.h | 2 +-
 scripts/kallsyms.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 5648870..6883e19 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 
-#define KSYM_NAME_LEN 255
+#define KSYM_NAME_LEN 128
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
 			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 48afa20..518da86c 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -27,7 +27,7 @@
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 #endif
 
-#define KSYM_NAME_LEN		255
+#define KSYM_NAME_LEN		128
 
 struct sym_entry {
 	unsigned long long addr;
-- 
1.8.1.4

