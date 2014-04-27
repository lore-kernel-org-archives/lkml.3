Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaD0RHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:07:52 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47981 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbaD0RHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:46 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Matt Ezell <ezellma@ornl.gov>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 06/47] staging/lustre/lnet: Dropped messages are not accounted correctly
Date: Sun, 27 Apr 2014 13:06:30 -0400
Message-Id: <1398618431-29757-7-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Ezell <ezellma@ornl.gov>

LNET messages that are dropped are not accounted for correctly in
/proc/sys/lnet/stats. What I assume to be a simple typo is causing
drop_length to be double-counted and drop_count to never be
incremented.

Signed-off-by: Matt Ezell <ezellma@ornl.gov>
Reviewed-on: http://review.whamcloud.com/9096
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4577
Reviewed-by: James Nunez <james.a.nunez@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lnet/lnet/api-ni.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index 45c2319..3f3c341 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -338,7 +338,7 @@ lnet_counters_get(lnet_counters_t *counters)
 		counters->send_count   += ctr->send_count;
 		counters->recv_count   += ctr->recv_count;
 		counters->route_count  += ctr->route_count;
-		counters->drop_length  += ctr->drop_length;
+		counters->drop_count   += ctr->drop_count;
 		counters->send_length  += ctr->send_length;
 		counters->recv_length  += ctr->recv_length;
 		counters->route_length += ctr->route_length;
-- 
1.8.5.3

