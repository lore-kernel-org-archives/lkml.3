Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3LSMPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:15:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45202 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab3LSL7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 160/208] arm64: mm: Fix PMD_SECT_PROT_NONE definition
Date: Thu, 19 Dec 2013 11:54:18 +0000
Message-Id: <1387454106-19326-161-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Capper <steve.capper@linaro.org>

commit db4ed53cfe9f5a00355891a631d47dfa3fd4541f upstream.

Modify the value of PMD_SECT_PROT_NONE to match that of PTE_NONE. This
should have been in commit 3676f9ef5481 (Move PTE_PROT_NONE higher up).

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/include/asm/pgtable-hwdef.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index e182a35..ccfeeee 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -43,7 +43,7 @@
  * Section
  */
 #define PMD_SECT_VALID		(_AT(pmdval_t, 1) << 0)
-#define PMD_SECT_PROT_NONE	(_AT(pmdval_t, 1) << 2)
+#define PMD_SECT_PROT_NONE	(_AT(pmdval_t, 1) << 58)
 #define PMD_SECT_USER		(_AT(pmdval_t, 1) << 6)		/* AP[1] */
 #define PMD_SECT_RDONLY		(_AT(pmdval_t, 1) << 7)		/* AP[2] */
 #define PMD_SECT_S		(_AT(pmdval_t, 3) << 8)
-- 
1.8.3.2

