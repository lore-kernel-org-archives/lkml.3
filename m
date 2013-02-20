Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934367Ab3BTSog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:44:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33557 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab3BTSof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:44:35 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: tj@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] idr: prevent NULL deref on lookups before insertions
Date: Wed, 20 Feb 2013 13:44:13 -0500
Message-Id: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'hint' will be NULL if we're looking up before adding anything
to the IDR.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/idr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index aed2a0c..a6f38b5 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -113,7 +113,7 @@ static inline void *idr_find(struct idr *idr, int id)
 {
 	struct idr_layer *hint = rcu_dereference_raw(idr->hint);
 
-	if ((id & ~IDR_MASK) == hint->prefix)
+	if (hint && (id & ~IDR_MASK) == hint->prefix)
 		return rcu_dereference_raw(hint->ary[id & IDR_MASK]);
 
 	return idr_find_slowpath(idr, id);
-- 
1.8.1.2

