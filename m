Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3AaL0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:26:16 -0500
Received: from msa105.auone-net.jp ([61.117.18.165]:46764 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3AaL0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:26:14 -0500
Date: Thu, 31 Jan 2013 20:26:12 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] ioprio: Allow CAP_SYS_NICE to set IOPRIO_CLASS_RT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20130131112612.E7F446FC039@msa105.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_setscheduler allows a process with CAP_SYS_NICE to set
real-time policy. Let ioprio_set follow this.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 fs/ioprio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ioprio.c b/fs/ioprio.c
index e50170c..155b51e 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -70,7 +70,7 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
 
 	switch (class) {
 		case IOPRIO_CLASS_RT:
-			if (!capable(CAP_SYS_ADMIN))
+			if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
 				return -EPERM;
 			/* fall through, rt has prio field too */
 		case IOPRIO_CLASS_BE:
-- 
1.7.10.4

