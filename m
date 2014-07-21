Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbaGUOLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:11:10 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557AbaGUOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:17 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, mingo@redhat.com,
        peterz@infradead.org
Subject: [PATCH 27/43] sas_ss_flags: Remove nested ternary if
Date: Mon, 21 Jul 2014 16:03:13 +0200
Message-Id: <1405951409-16953-28-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

...to make it readable.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/sched.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0376b05..795ea2b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2360,8 +2360,10 @@ static inline int on_sig_stack(unsigned long sp)
 
 static inline int sas_ss_flags(unsigned long sp)
 {
-	return (current->sas_ss_size == 0 ? SS_DISABLE
-		: on_sig_stack(sp) ? SS_ONSTACK : 0);
+	if (!current->sas_ss_size)
+		return SS_DISABLE;
+
+	return on_sig_stack(sp) ? SS_ONSTACK : 0;
 }
 
 static inline unsigned long sigsp(unsigned long sp, struct ksignal *ksig)
-- 
1.8.4.5

