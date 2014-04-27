Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaD0RQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:16:19 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48076 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbaD0RIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:20 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 30/47] staging/lustre/mdc: fix issue found by Klocwork Insight tool
Date: Sun, 27 Apr 2014 13:06:54 -0400
Message-Id: <1398618431-29757-31-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Pointer 'mod' checked for NULL at line 160 may be dereferenced at line 208.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9387
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_reint.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
index 19f20c1..08e8094 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_reint.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
@@ -199,7 +199,8 @@ int mdc_setattr(struct obd_export *exp, struct md_op_data *op_data,
 	*request = req;
 	if (rc && req->rq_commit_cb) {
 		/* Put an extra reference on \var mod on error case. */
-		obd_mod_put(*mod);
+		if (mod != NULL && *mod != NULL)
+			obd_mod_put(*mod);
 		req->rq_commit_cb(req);
 	}
 	return rc;
-- 
1.8.5.3

