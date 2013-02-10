Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961Ab3BJAkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 19:40:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45246 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab3BJAkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 19:40:06 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 04/11] liblockdep: fix AA test
Date: Sat,  9 Feb 2013 19:39:34 -0500
Message-Id: <1360456781-32462-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were accidently unlocking the dummy mutex in the test, which meant
that we were testing unlock balance instead of AA deadlock.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/tests/AA.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/lockdep/tests/AA.c b/tools/lib/lockdep/tests/AA.c
index a443e65..0f782ff 100644
--- a/tools/lib/lockdep/tests/AA.c
+++ b/tools/lib/lockdep/tests/AA.c
@@ -8,6 +8,6 @@ void main(void)
 	pthread_mutex_init(&b, NULL);
 
 	pthread_mutex_lock(&a);
-	pthread_mutex_unlock(&b);
+	pthread_mutex_lock(&b);
 	pthread_mutex_lock(&a);
 }
-- 
1.8.1.2

