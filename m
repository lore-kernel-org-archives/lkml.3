Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3KUSqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:46:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:49101 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754186Ab3KUSqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:46:30 -0500
Message-Id: <20131121184629.647339591@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 13:43:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <bitbucket@online.de>
Subject: [PATCH RT 2/5] hwlat-detector: Dont ignore threshold module parameter
References: <20131121184357.391591135@goodmis.org>
Content-Disposition: inline; filename=0002-hwlat-detector-Don-t-ignore-threshold-module-paramet.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rt74-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mike Galbraith <bitbucket@online.de>

If the user specified a threshold at module load time, use it.

Cc: stable-rt@vger.kernel.org
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/misc/hwlat_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index 6f61d5f..d2676b8 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -413,7 +413,7 @@ static int init_stats(void)
 		goto out;
 
 	__reset_stats();
-	data.threshold = DEFAULT_LAT_THRESHOLD;	    /* threshold us */
+	data.threshold = threshold ?: DEFAULT_LAT_THRESHOLD;	    /* threshold us */
 	data.sample_window = DEFAULT_SAMPLE_WINDOW; /* window us */
 	data.sample_width = DEFAULT_SAMPLE_WIDTH;   /* width us */
 
-- 
1.8.4.rc3


