Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161003Ab3BFWQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:16:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37536 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab3BFWML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:12:11 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 05/11] liblockdep: correct the ABCDBCDA test
Date: Wed,  6 Feb 2013 17:11:28 -0500
Message-Id: <1360188694-25077-6-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to use liblockdep specific calls, they are wrapped for us.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/tests/ABCDBCDA.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/lib/lockdep/tests/ABCDBCDA.c b/tools/lib/lockdep/tests/ABCDBCDA.c
index aadf11e..427ba56 100644
--- a/tools/lib/lockdep/tests/ABCDBCDA.c
+++ b/tools/lib/lockdep/tests/ABCDBCDA.c
@@ -3,12 +3,12 @@
 
 void main(void)
 {
-	liblockdep_pthread_mutex_t a, b, c, d;
+	pthread_mutex_t a, b, c, d;
 
-	liblockdep_pthread_mutex_init(&a, NULL);
-	liblockdep_pthread_mutex_init(&b, NULL);
-	liblockdep_pthread_mutex_init(&c, NULL);
-	liblockdep_pthread_mutex_init(&d, NULL);
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+	pthread_mutex_init(&d, NULL);
 
 	LOCK_UNLOCK_2(a, b);
 	LOCK_UNLOCK_2(c, d);
-- 
1.8.1.2

