Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbaIHV3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:29:50 -0400
Received: from gproxy3-pub.mail.unifiedlayer.com ([69.89.30.42]:56867 "HELO
	gproxy3-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754254AbaIHV3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:29:49 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 17:29:49 EDT
X-Authority-Analysis: v=2.1 cv=e5mVF8Z/ c=1 sm=1 tr=0
 a=PkLafpyMt2xwRD+PMJrZ3Q==:117 a=PkLafpyMt2xwRD+PMJrZ3Q==:17 a=cNaOj0WVAAAA:8
 a=f5113yIGAAAA:8 a=J0QyKEt1u0cA:10 a=0ibgGAIqaMQA:10 a=bBxL3RAuNjMA:10
 a=tpfS5X3q9NgA:10 a=kj9zAlcOel0A:10 a=ptNznvi-AAAA:8 a=fztpppUj2ZoA:10
 a=Xwexni91U_8A:10 a=6xDDb1LLBC2NsPcj-KQA:9 a=CjuIK1q_8ugA:10 a=-L_9wej9Mi0A:10
Date: Mon, 8 Sep 2014 15:22:58 -0600
From: Eddie Kovsky <ewk@edkovsky.org>
To: gregkh@linuxfoundation.org
Cc: andreas.dilger@intel.com, green@linuxhacker.ru, bergwolf@gmail.com,
        uja.ornl@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vgter.kernel.org
Subject: [PATCH] staging: clean up checkpatch warnings in lustre
Message-ID: <20140908212257.GA15142@athena>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Identified-User: {1650:box492.bluehost.com:edkovsky:edkovsky.org} {sentby:smtp auth 65.102.196.57 authed with ewk+edkovsky.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence checkpatch warning:

WARNING: type 'long long unsigned' should be specified in
[[un]signed] [short|int|long|long long] order

Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
---
 drivers/staging/lustre/lustre/fid/lproc_fid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
index 92a27fa..ecf654e 100644
--- a/drivers/staging/lustre/lustre/fid/lproc_fid.c
+++ b/drivers/staging/lustre/lustre/fid/lproc_fid.c
@@ -84,8 +84,8 @@ static int lprocfs_fid_write_common(const char __user *buffer, size_t count,
 
 	/* of the form "[0x0000000240000400 - 0x000000028000400]" */
 	rc = sscanf(kernbuf, "[%llx - %llx]\n",
-		    (long long unsigned *)&tmp.lsr_start,
-		    (long long unsigned *)&tmp.lsr_end);
+		    (unsigned long long *)&tmp.lsr_start,
+		    (unsigned long long *)&tmp.lsr_end);
 	if (!range_is_sane(&tmp) || range_is_zero(&tmp) ||
 	    tmp.lsr_start < range->lsr_start || tmp.lsr_end > range->lsr_end)
 		return -EINVAL;
-- 
1.9.3

