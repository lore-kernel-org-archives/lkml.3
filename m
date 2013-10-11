Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3JKKmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3JKKmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Jonghwan Choi <jhbird.choi@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 018/100] cfq: explicitly use 64bit divide operation for 64bit arguments
Date: Fri, 11 Oct 2013 11:40:48 +0100
Message-Id: <1381488130-30235-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatol Pomozov <anatol.pomozov@gmail.com>

commit f3cff25f05f2ac29b2ee355e611b0657482f6f1d upstream.

'samples' is 64bit operant, but do_div() second parameter is 32.
do_div silently truncates high 32 bits and calculated result
is invalid.

In case if low 32bit of 'samples' are zeros then do_div() produces
kernel crash.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Jonghwan Choi <jhbird.choi@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/cfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fb52df9..4d27120 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1484,7 +1484,7 @@ static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
 
 	if (samples) {
 		v = blkg_stat_read(&cfqg->stats.avg_queue_size_sum);
-		do_div(v, samples);
+		v = div64_u64(v, samples);
 	}
 	__blkg_prfill_u64(sf, pd, v);
 	return 0;
-- 
1.8.3.2

