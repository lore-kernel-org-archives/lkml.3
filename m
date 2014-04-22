Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbaDVOvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:51:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819AbaDVOvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:51:10 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH RESEND 2/2] percpu_ida: Sanity check initialization parameters
Date: Tue, 22 Apr 2014 16:51:56 +0200
Message-Id: <7a7d22c2cda445c4a1170c9c13a66a2c32b2c9e7.1398178132.git.agordeev@redhat.com>
In-Reply-To: <cover.1398178132.git.agordeev@redhat.com>
References: <cover.1398178132.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Acked-by: Kent Overstreet <kmo@daterainc.com>
---
 lib/percpu_ida.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 472ff08..f474f03 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -293,6 +293,11 @@ int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
 {
 	unsigned i, cpu, order;
 
+	if (batch_size > max_size)
+		return -ERANGE;
+	if (!batch_size)
+		return -EINVAL;
+
 	memset(pool, 0, sizeof(*pool));
 
 	init_waitqueue_head(&pool->wait);
-- 
1.7.7.6

