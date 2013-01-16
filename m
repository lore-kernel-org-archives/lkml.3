Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3APRNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:13:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3APP6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 017/222] ARM: mm: use pteval_t to represent page protection values
Date: Wed, 16 Jan 2013 13:53:37 -0200
Message-Id: <1358351822-7675-18-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 864aa04cd02979c2c755cb28b5f4fe56039171c0 upstream.

When updating the page protection map after calculating the user_pgprot
value, the base protection map is temporarily stored in an unsigned long
type, causing truncation of the protection bits when LPAE is enabled.
This effectively means that calls to mprotect() will corrupt the upper
page attributes, clearing the XN bit unconditionally.

This patch uses pteval_t to store the intermediate protection values,
preserving the upper bits for 64-bit descriptors.

Acked-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 15c6abe..f117e1f 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -504,7 +504,7 @@ static void __init build_mem_type_table(void)
 #endif
 
 	for (i = 0; i < 16; i++) {
-		unsigned long v = pgprot_val(protection_map[i]);
+		pteval_t v = pgprot_val(protection_map[i]);
 		protection_map[i] = __pgprot(v | user_pgprot);
 	}
 
-- 
1.7.9.5

