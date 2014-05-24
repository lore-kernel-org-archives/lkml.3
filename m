Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaEXHLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:11:18 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:42449 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaEXHJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:09:25 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 14/24] ARM64:ILP32: COMPAT_USE_64BIT_TIME is true for ILP32 tasks.
Date: Sat, 24 May 2014 00:02:09 -0700
Message-Id: <1400914939-9708-15-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since __kernel_long_t (time_t) is long long, we need to tell the rest of kernel that we use 64bit time_t for compat when the task is not an AARCH32 task.  The reason why we check AARCH32 rather than ILP32 here is because if we don't have AARCH32 compiled in (which is going to be the common case due to AARCH32 requiring 4k pages).

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/compat.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 85f945c..c77fc0f 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -76,6 +76,9 @@ struct compat_timeval {
 	s32		tv_usec;
 };
 
+/* ILP32 uses 64bit time_t and not the above compat structures */
+#define COMPAT_USE_64BIT_TIME !is_a32_compat_task()
+
 struct compat_stat {
 #ifdef __AARCH64EB__
 	short		st_dev;
-- 
1.7.2.5

