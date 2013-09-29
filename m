Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab3I2TvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:51:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab3I2T2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anatol Pomozov <anatol.pomozov@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jonghwan Choi <jhbird.choi@gmail.com>
Subject: [ 44/49] cfq: explicitly use 64bit divide operation for 64bit arguments
Date: Sun, 29 Sep 2013 12:27:18 -0700
Message-Id: <20130929191605.993599947@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/cfq-iosched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1803,7 +1803,7 @@ static u64 cfqg_prfill_avg_queue_size(st
 
 	if (samples) {
 		v = blkg_stat_read(&cfqg->stats.avg_queue_size_sum);
-		do_div(v, samples);
+		v = div64_u64(v, samples);
 	}
 	__blkg_prfill_u64(sf, pd, v);
 	return 0;


