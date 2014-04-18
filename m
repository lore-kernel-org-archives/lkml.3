Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaDRMr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:47:29 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:61818 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754264AbaDRMrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:47:24 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29445308"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 8/8] idr: reduce the unneeded check in free_layer()
Date: Fri, 18 Apr 2014 20:49:55 +0800
Message-ID: <1397825404-12039-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "idr->hint == p" is true, it also implies "idr->hint" is true(not NULL).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 314ea5f..08d010c 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -143,7 +143,7 @@ static void idr_layer_rcu_free(struct rcu_head *head)
 
 static inline void free_layer(struct idr *idr, struct idr_layer *p)
 {
-	if (idr->hint && idr->hint == p)
+	if (idr->hint == p)
 		RCU_INIT_POINTER(idr->hint, NULL);
 	call_rcu(&p->rcu_head, idr_layer_rcu_free);
 }
-- 
1.7.4.4

