Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaG1PCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:02:08 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65431 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaG1PB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:01:59 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [IA64] Do not needlessly convert between pointers and integers
Date: Mon, 28 Jul 2014 17:01:49 +0200
Message-Id: <1406559709-9401-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406559709-9401-1-git-send-email-thierry.reding@gmail.com>
References: <1406559709-9401-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The nasid_to_try variable is an array of integers, so plain integers can
be used when assigning values to the elements rather than casting a NULL
pointer to an integer, which results in the following warning from GCC:

	arch/ia64/sn/kernel/bte.c:117:22: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
	    nasid_to_try[1] = (int)NULL;
	                      ^
	arch/ia64/sn/kernel/bte.c:125:22: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
	    nasid_to_try[1] = (int)NULL;
	                      ^

Replace (int)NULL with a simple 0 to silence these warnings.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/ia64/sn/kernel/bte.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/sn/kernel/bte.c b/arch/ia64/sn/kernel/bte.c
index cad775a1a157..b2eb48490754 100644
--- a/arch/ia64/sn/kernel/bte.c
+++ b/arch/ia64/sn/kernel/bte.c
@@ -114,7 +114,7 @@ bte_result_t bte_copy(u64 src, u64 dest, u64 len, u64 mode, void *notification)
 		if (mode & BTE_USE_ANY) {
 			nasid_to_try[1] = my_nasid;
 		} else {
-			nasid_to_try[1] = (int)NULL;
+			nasid_to_try[1] = 0;
 		}
 	} else {
 		/* try local then remote */
@@ -122,7 +122,7 @@ bte_result_t bte_copy(u64 src, u64 dest, u64 len, u64 mode, void *notification)
 		if (mode & BTE_USE_ANY) {
 			nasid_to_try[1] = NASID_GET(dest);
 		} else {
-			nasid_to_try[1] = (int)NULL;
+			nasid_to_try[1] = 0;
 		}
 	}
 
-- 
2.0.2

