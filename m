Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbaICVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:25:57 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61503 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbaICVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:28 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 12/24] ARM64:ILP32: COMPAT_USE_64BIT_TIME is true for ILP32 tasks
Date: Wed,  3 Sep 2014 14:19:06 -0700
Message-Id: <1409779158-30963-13-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since __kernel_long_t (time_t) is long long, we need to tell the rest of
kernel that we use 64bit time_t for compat when the task is not an
AARCH32 task.  The reason why we check AARCH32 rather than ILP32 here is
because if we don't have AARCH32 compiled in (which is going to be the common case due to AARCH32 requiring 4k pages).

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/compat.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 9082b27..eca6eec 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -76,6 +76,9 @@ struct compat_timeval {
 	s32		tv_usec;
 };
 
+/* ILP32 uses 64bit time_t and not the above compat structures */
+#define COMPAT_USE_64BIT_TIME (!is_a32_compat_task())
+
 struct compat_stat {
 #ifdef __AARCH64EB__
 	short		st_dev;
-- 
1.7.2.5

