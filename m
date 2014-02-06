Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaBFMXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:23:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220AbaBFMXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:23:35 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH RESEND 3/3] percpu_ida: Sanity check initialization parameters
Date: Thu,  6 Feb 2014 13:24:55 +0100
Message-Id: <a883f10da60a023134928bd9be01b37e7c55df0d.1391688720.git.agordeev@redhat.com>
In-Reply-To: <cover.1391688720.git.agordeev@redhat.com>
References: <cover.1391688720.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
---
 lib/percpu_ida.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index c2fa3dc..81b5ae9 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -305,6 +305,11 @@ int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
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

