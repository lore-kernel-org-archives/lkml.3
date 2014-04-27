Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaD0RH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:07:56 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47975 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaD0RHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:45 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Niu Yawei <yawei.niu@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 08/47] staging/lustre/clio: clear nowait flag agl lock re-enqueue
Date: Sun, 27 Apr 2014 13:06:32 -0400
Message-Id: <1398618431-29757-9-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niu Yawei <yawei.niu@intel.com>

The LDLM_FL_BLOCK_NOWAIT flag should be cleared when re-enqueue
the agl lock as normal glimpse, otherwise, it won't get size back
if there is conflicting locks on other client.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-on: http://review.whamcloud.com/9249
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4597
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Ned Bass <bass6@llnl.gov>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_lock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/osc/osc_lock.c b/drivers/staging/lustre/lustre/osc/osc_lock.c
index ef7b9c2..1c6cafa 100644
--- a/drivers/staging/lustre/lustre/osc/osc_lock.c
+++ b/drivers/staging/lustre/lustre/osc/osc_lock.c
@@ -1192,6 +1192,7 @@ static int osc_lock_wait(const struct lu_env *env,
 
 		LASSERT(olck->ols_agl);
 		olck->ols_agl = 0;
+		olck->ols_flags &= ~LDLM_FL_BLOCK_NOWAIT;
 		rc = osc_lock_enqueue(env, slice, NULL, CEF_ASYNC | CEF_MUST);
 		if (rc != 0)
 			return rc;
-- 
1.8.5.3

