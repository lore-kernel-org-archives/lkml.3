Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaGBKy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:54:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53159 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaGBKy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:54:26 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: teobaluta@gmail.com, oleg.drokin@intel.com, dmitry.eremin@intel.com,
        bergwolf@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v2 1/1] staging: lustre: libcfs: nidstrings.c - use ARRAY_SIZE macro
Date: Wed,  2 Jul 2014 16:23:55 +0530
Message-Id: <1404298435-9729-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this patch replaces sizeof(a)/sizeof(a[0]) with the ARRAY_SIZE macro
  to get the number of nidstrings (and netstrfns)
- v2: also for netstrfns

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/nidstrings.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/nidstrings.c b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
index 87705ae..4fc7b45 100644
--- a/drivers/staging/lustre/lustre/libcfs/nidstrings.c
+++ b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
@@ -74,8 +74,7 @@ libcfs_next_nidstring(void)
 	spin_lock_irqsave(&libcfs_nidstring_lock, flags);
 
 	str = libcfs_nidstrings[libcfs_nidstring_idx++];
-	if (libcfs_nidstring_idx ==
-	    sizeof(libcfs_nidstrings)/sizeof(libcfs_nidstrings[0]))
+	if (libcfs_nidstring_idx == ARRAY_SIZE(libcfs_nidstrings))
 		libcfs_nidstring_idx = 0;
 
 	spin_unlock_irqrestore(&libcfs_nidstring_lock, flags);
@@ -198,7 +197,7 @@ static struct netstrfns  libcfs_netstrfns[] = {
 	{/* .nf_type      */  -1},
 };
 
-const int libcfs_nnetstrfns = sizeof(libcfs_netstrfns)/sizeof(libcfs_netstrfns[0]);
+const int libcfs_nnetstrfns = ARRAY_SIZE(libcfs_netstrfns);
 
 int
 libcfs_lo_str2addr(const char *str, int nob, __u32 *addr)
-- 
1.9.1

