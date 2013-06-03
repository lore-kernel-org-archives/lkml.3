Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab3FCWWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:22:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804Ab3FCWMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:00 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=CIibLl7Jrs4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=eaz7EpK6WUsA:10 a=YhdJeHolAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=cIlJEn9swfgASWA2gWUA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221153.475194479@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [08/65] dm snapshot: fix error return code in snapshot_ctr
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0008-dm-snapshot-fix-error-return-code-in-snapshot_ctr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit 09e8b813897a0f85bb401435d009228644c81214 ]

Return -ENOMEM instead of success if unable to allocate pending
exception mempool in snapshot_ctr.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/dm-snap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index a143921..456ef7a 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1117,6 +1117,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
 	if (!s->pending_pool) {
 		ti->error = "Could not allocate mempool for pending exceptions";
+		r = -ENOMEM;
 		goto bad_pending_pool;
 	}
 
-- 
1.7.10.4


