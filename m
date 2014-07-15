Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbaGOVjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:39:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55096 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874AbaGOVjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 055/198] s390/time: cast tv_nsec to u64 prior to shift in update_vsyscall
Date: Tue, 15 Jul 2014 14:28:45 -0700
Message-Id: <1405459868-15089-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit b6f4296279ab3ada554d993d12844272fd86b36a upstream.

Analog to git commit 28b92e09e25bdc0ae864b22eacf195a74f861389
first cast tk->wall_to_monotonic.tv_nsec to u64 before doing
the shift with tk->shift to avoid loosing relevant bits on a
32-bit kernel.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index dd95f163..a80190b 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -226,7 +226,7 @@ void update_vsyscall(struct timekeeper *tk)
 	vdso_data->wtom_clock_sec =
 		tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
 	vdso_data->wtom_clock_nsec = tk->xtime_nsec +
-		+ (tk->wall_to_monotonic.tv_nsec << tk->shift);
+		+ ((u64) tk->wall_to_monotonic.tv_nsec << tk->shift);
 	nsecps = (u64) NSEC_PER_SEC << tk->shift;
 	while (vdso_data->wtom_clock_nsec >= nsecps) {
 		vdso_data->wtom_clock_nsec -= nsecps;
-- 
1.9.1

