Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaJCWHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:07:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaJCWGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:06:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Philippe De Muyter <phdm@macqel.be>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.16 345/357] partitions: aix.c: off by one bug
Date: Fri,  3 Oct 2014 14:32:11 -0700
Message-Id: <20141003212943.816280210@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d97a86c170b4e432f76db072a827fe30b4d6f659 upstream.

The lvip[] array has "state->limit" elements so the condition here
should be >= instead of >.

Fixes: 6ceea22bbbc8 ('partitions: add aix lvm partition support files')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/partitions/aix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/partitions/aix.c
+++ b/block/partitions/aix.c
@@ -253,7 +253,7 @@ int aix_partition(struct parsed_partitio
 				continue;
 			}
 			lv_ix = be16_to_cpu(p->lv_ix) - 1;
-			if (lv_ix > state->limit) {
+			if (lv_ix >= state->limit) {
 				cur_lv_ix = -1;
 				continue;
 			}


