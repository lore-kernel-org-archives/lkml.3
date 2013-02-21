Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3BUFV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 00:21:58 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33350 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3BUFV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 00:21:57 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 1/2] block: partitions: mac: obey the state->limit constraint
Date: Thu, 21 Feb 2013 13:21:40 +0800
Message-Id: <1361424101-24936-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't necessary to read the information of partitions whose No.
is equal and more than state->limit since only maximum state->limit
partitions will be added inside rescan_partitions().

That is also what other kind of partitions are doing.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/partitions/mac.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/partitions/mac.c b/block/partitions/mac.c
index 11f688b..76d8ba6 100644
--- a/block/partitions/mac.c
+++ b/block/partitions/mac.c
@@ -63,6 +63,10 @@ int mac_partition(struct parsed_partitions *state)
 		put_dev_sector(sect);
 		return 0;
 	}
+
+	if (blocks_in_map >= state->limit)
+		blocks_in_map = state->limit - 1;
+
 	strlcat(state->pp_buf, " [mac]", PAGE_SIZE);
 	for (slot = 1; slot <= blocks_in_map; ++slot) {
 		int pos = slot * secsize;
-- 
1.7.9.5

