Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab3EQWJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:09:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3EQVrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 06/50] dm snapshot: fix error return code in snapshot_ctr
Date: Fri, 17 May 2013 14:46:41 -0700
Message-Id: <20130517213843.294383446@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1117,6 +1117,7 @@ static int snapshot_ctr(struct dm_target
 	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
 	if (!s->pending_pool) {
 		ti->error = "Could not allocate mempool for pending exceptions";
+		r = -ENOMEM;
 		goto bad_pending_pool;
 	}
 


