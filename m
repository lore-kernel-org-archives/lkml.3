Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab3J1KD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:03:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab3J1KD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:03:56 -0400
Date: Mon, 28 Oct 2013 11:06:06 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] percpu_ida: Sanity check initialization parameters
Message-ID: <20131028100605.GE5744@dhcp-26-207.brq.redhat.com>
References: <cover.1382950629.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1382950629.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 lib/percpu_ida.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 4adc3e5..1fc89f9 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -298,6 +298,11 @@ int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
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


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
