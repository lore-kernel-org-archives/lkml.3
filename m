Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaBINSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:18:51 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39353 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaBINSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:18:49 -0500
Date: Sun, 9 Feb 2014 18:48:44 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Sameer Nanda <snanda@chromium.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        josh@joshtriplett.org
Subject: [PATCH 17/21] fs: Mark function as static in proc/array.c
Message-ID: <a85f6b9aa721058b0ad20cfee0b337f356df7c1a.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in proc/array.c because it is not used outside
this file.

This eliminates the following warning in proc/array.c:
fs/proc/array.c:712:5: warning: no previous prototype for ‘children_seq_release’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 656e401..2265b11 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -699,7 +699,7 @@ static int children_seq_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-int children_seq_release(struct inode *inode, struct file *file)
+static int children_seq_release(struct inode *inode, struct file *file)
 {
 	seq_release(inode, file);
 	return 0;
-- 
1.7.9.5

