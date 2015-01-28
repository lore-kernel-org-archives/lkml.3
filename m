Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359AbbA1E01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:26:27 -0500
Received: from mail.kernel.org ([198.145.29.136]:41429 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965327AbbA1E0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:26:23 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nsn.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 169/177] MIPS: oprofile: Fix backtrace on 64-bit kernel
Date: Wed, 28 Jan 2015 12:10:27 +0800
Message-Id: <1422418236-12852-260-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@nsn.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit bbaf113a481b6ce32444c125807ad3618643ce57 upstream.

Fix incorrect cast that always results in wrong address for the new
frame on 64-bit kernels.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8110/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/mips/oprofile/backtrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/oprofile/backtrace.c b/arch/mips/oprofile/backtrace.c
index 6854ed5..83a1dfd 100644
--- a/arch/mips/oprofile/backtrace.c
+++ b/arch/mips/oprofile/backtrace.c
@@ -92,7 +92,7 @@ static inline int unwind_user_frame(struct stackframe *old_frame,
 				/* This marks the end of the previous function,
 				   which means we overran. */
 				break;
-			stack_size = (unsigned) stack_adjustment;
+			stack_size = (unsigned long) stack_adjustment;
 		} else if (is_ra_save_ins(&ip)) {
 			int ra_slot = ip.i_format.simmediate;
 			if (ra_slot < 0)
-- 
1.9.1

