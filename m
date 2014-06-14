Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbaFNXIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 19:08:41 -0400
Received: from mx02.posteo.de ([89.146.194.165]:34129 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750818AbaFNXIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 19:08:40 -0400
From: Martin Kepplinger <martink@posteo.de>
To: drbd-dev@lists.linbit.com
Cc: drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] drbd: change one-bit bitfield to be an unsigned int
Date: Sun, 15 Jun 2014 01:07:55 +0200
Message-Id: <1402787275-12258-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The one-bit bitfield has no negative values and thus becomes an
unsigned int.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
No idea if you take such small changes. Please ignore if not.
This applies to next-20140613 and fixes a sparse error.


 drivers/block/drbd/drbd_interval.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
index f38fcb0..68b4301 100644
--- a/drivers/block/drbd/drbd_interval.h
+++ b/drivers/block/drbd/drbd_interval.h
@@ -9,8 +9,8 @@ struct drbd_interval {
 	sector_t sector;	/* start sector of the interval */
 	unsigned int size;	/* size in bytes */
 	sector_t end;		/* highest interval end in subtree */
-	int local:1		/* local or remote request? */;
-	int waiting:1;
+	unsigned int local:1		/* local or remote request? */;
+	unsigned int waiting:1;
 };
 
 static inline void drbd_clear_interval(struct drbd_interval *i)
-- 
1.7.10.4

