Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbbANIEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:04:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbbANHeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:34:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.14 27/77] blk-mq: use nr_cpu_ids as highest CPU ID count for hwq <-> cpu map
Date: Tue, 13 Jan 2015 23:23:07 -0800
Message-Id: <20150114072225.687619367@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@fb.com>

commit a33c1ba2913802b6fb23e974bb2f6a4e73c8b7ce upstream.

We currently use num_possible_cpus(), but that breaks on sparc64 where
the CPU ID space is discontig. Use nr_cpu_ids as the highest CPU ID
instead, so we don't end up reading from invalid memory.

Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq-cpumap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -95,7 +95,7 @@ unsigned int *blk_mq_make_queue_map(stru
 	unsigned int *map;
 
 	/* If cpus are offline, map them to first hctx */
-	map = kzalloc_node(sizeof(*map) * num_possible_cpus(), GFP_KERNEL,
+	map = kzalloc_node(sizeof(*map) * nr_cpu_ids, GFP_KERNEL,
 				reg->numa_node);
 	if (!map)
 		return NULL;


