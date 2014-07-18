Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbaGRNKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:10:11 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17481 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030451AbaGRNKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:08 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Benjamin LaHaise <bcrl@kvack.org>, Mateusz Guzik <mguzik@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3.12 001/170] Revert "aio: fix kernel memory disclosure in io_getevents() introduced in v3.10"
Date: Fri, 18 Jul 2014 14:10:06 +0200
Message-Id: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

This reverts commit 0e2e24e5dc6eb6f0698e9dc97e652f132b885624, which
was applied twice mistakenly. The first one is
bee3f7b8188d4b2a5dfaeb2eb4a68d99f67daecf.

Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
---
 fs/aio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 0abde33de70e..e609e15f36b9 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1066,9 +1066,6 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	head %= ctx->nr_events;
 	tail %= ctx->nr_events;
 
-	head %= ctx->nr_events;
-	tail %= ctx->nr_events;
-
 	while (ret < nr) {
 		long avail;
 		struct io_event *ev;
-- 
2.0.0

