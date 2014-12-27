Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaL0UsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:48:09 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63194 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaL0UsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:48:05 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Greg Donald <gdonald@gmail.com>, Anton Saraev <antonysaraev@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, Joe Perches <joe@perches.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 4/5] staging: lustre: selftest: fix _post_buffer context imbalance
Date: Sat, 27 Dec 2014 12:46:49 -0800
Message-Id: <1419713210-8198-5-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
References: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the sparse warning about a context imbalance in the
srpc_service_post_buffer function by telling sparse that it
should expect the lock to be held on entry and held on exit.

  drivers/staging/lustre/lnet/selftest/rpc.c:508:17: warning: context imbalance in 'srpc_service_post_buffer' - unexpected unlock

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/selftest/rpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index bb6aa2e..2e9094b 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -468,6 +468,7 @@ srpc_post_passive_rqtbuf(int service, int local, void *buf, int len,
 
 static int
 srpc_service_post_buffer(struct srpc_service_cd *scd, struct srpc_buffer *buf)
+	__must_hold(&scd->scd_lock)
 {
 	struct srpc_service	*sv = scd->scd_svc;
 	struct srpc_msg		*msg = &buf->buf_msg;
-- 
2.1.4

