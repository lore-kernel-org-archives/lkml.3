Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaHEIKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:10:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46232 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbaHEIKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:10:32 -0400
Date: Tue, 5 Aug 2014 11:09:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>, Philippe De Muyter <phdm@macqel.be>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] partitions: aix.c: off by one bug
Message-ID: <20140805080959.GA13605@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lvip[] array has "state->limit" elements so the condition here
should be >= instead of >.

Fixes: 6ceea22bbbc8 ('partitions: add aix lvm partition support files')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/block/partitions/aix.c b/block/partitions/aix.c
index 0a6ed54..f3ed7b2 100644
--- a/block/partitions/aix.c
+++ b/block/partitions/aix.c
@@ -253,7 +253,7 @@ int aix_partition(struct parsed_partitions *state)
 				continue;
 			}
 			lv_ix = be16_to_cpu(p->lv_ix) - 1;
-			if (lv_ix > state->limit) {
+			if (lv_ix >= state->limit) {
 				cur_lv_ix = -1;
 				continue;
 			}
