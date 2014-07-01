Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbaGAEzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 00:55:43 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36010 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaGAEzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 00:55:42 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: teobaluta@gmail.com, oleg.drokin@intel.com, dmitry.eremin@intel.com,
        bergwolf@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] staging: lustre: libcfs: nidstrings.c - use ARRAY_SIZE macro
Date: Tue,  1 Jul 2014 10:25:25 +0530
Message-Id: <1404190525-13449-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this patch replaces sizeof(a)/sizeof(a[0]) with the ARRAY_SIZE macro
  to get the number of nidstrings

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/nidstrings.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/nidstrings.c b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
index 87705ae..13a2791 100644
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
-- 
1.9.1

