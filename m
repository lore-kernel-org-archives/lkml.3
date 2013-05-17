Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab3EQVu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:50:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab3EQVuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 05/33] dm snapshot: fix error return code in snapshot_ctr
Date: Fri, 17 May 2013 14:49:49 -0700
Message-Id: <20130517214917.452331610@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 09e8b813897a0f85bb401435d009228644c81214 upstream.

Return -ENOMEM instead of success if unable to allocate pending
exception mempool in snapshot_ctr.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-snap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1121,6 +1121,7 @@ static int snapshot_ctr(struct dm_target
 	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
 	if (!s->pending_pool) {
 		ti->error = "Could not allocate mempool for pending exceptions";
+		r = -ENOMEM;
 		goto bad_pending_pool;
 	}
 


