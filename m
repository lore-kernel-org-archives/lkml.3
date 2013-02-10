Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898Ab3BJAkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 19:40:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40749 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3BJAkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 19:40:06 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 05/11] liblockdep: correct the ABCDBCDA test
Date: Sat,  9 Feb 2013 19:39:35 -0500
Message-Id: <1360456781-32462-5-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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

