Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3F1S6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:58:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab3F1S6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:58:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 056/105] ARM: 7754/1: Fix the CPU ID and the mask associated to the PJ4B
Date: Fri, 28 Jun 2013 11:51:18 -0700
Message-Id: <1372445527-24414-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

commit 049be07053ebbf0ee8543caea23ae7bdf0765bb2 upstream.

This commit fixes the ID and mask for the PJ4B which was too
restrictive and didn't match the CPU of the Armada 370 SoC.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mm/proc-v7.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 3a3c015..1b09ef1 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -407,8 +407,8 @@ __v7_ca9mp_proc_info:
 	 */
 	.type   __v7_pj4b_proc_info, #object
 __v7_pj4b_proc_info:
-	.long	0x562f5840
-	.long	0xfffffff0
+	.long	0x560f5800
+	.long	0xff0fff00
 	__v7_proc __v7_pj4b_setup
 	.size	__v7_pj4b_proc_info, . - __v7_pj4b_proc_info
 #endif	/* CONFIG_ARM_LPAE */
-- 
1.8.1.2

