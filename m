Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaCENbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:31:50 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51989 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbaCENbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:31:47 -0500
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 6/6] staging/lustre/libcfs: remove NIDSTR_LOCK/UNLOCK
Date: Wed,  5 Mar 2014 21:27:20 +0800
Message-Id: <1394026040-1968-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1394026040-1968-5-git-send-email-bergwolf@gmail.com>
References: <1394026040-1968-1-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-2-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-3-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-4-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-5-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/nidstrings.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/nidstrings.c b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
index 732ae55..cfb274f 100644
--- a/drivers/staging/lustre/lustre/libcfs/nidstrings.c
+++ b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
@@ -65,23 +65,20 @@ void libcfs_init_nidstrings(void)
 	spin_lock_init(&libcfs_nidstring_lock);
 }
 
-# define NIDSTR_LOCK(f)   spin_lock_irqsave(&libcfs_nidstring_lock, f)
-# define NIDSTR_UNLOCK(f) spin_unlock_irqrestore(&libcfs_nidstring_lock, f)
-
 static char *
 libcfs_next_nidstring(void)
 {
 	char	  *str;
 	unsigned long  flags;
 
-	NIDSTR_LOCK(flags);
+	spin_lock_irqsave(&libcfs_nidstring_lock, flags);
 
 	str = libcfs_nidstrings[libcfs_nidstring_idx++];
 	if (libcfs_nidstring_idx ==
 	    sizeof(libcfs_nidstrings)/sizeof(libcfs_nidstrings[0]))
 		libcfs_nidstring_idx = 0;
 
-	NIDSTR_UNLOCK(flags);
+	spin_unlock_irqrestore(&libcfs_nidstring_lock, flags);
 	return str;
 }
 
-- 
1.7.7.6

