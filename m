Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaFDUsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:48:30 -0400
Received: from mxip6-inbound.gatech.edu ([130.207.182.15]:19360 "EHLO
	mxip6-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFDUs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:48:28 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2014 16:48:28 EDT
X-RemoteIP: 130.207.185.167
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 88976381
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.98,975,1392181200"; 
   d="scan'208";a="88976381"
X-GT-Spam-Rating: (0%)
Message-ID: <538F83DF.8090303@gatech.edu>
Date: Wed, 04 Jun 2014 16:38:55 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/1] remove redundant compare, cmpxchg already does it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove a redundant comparision

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/locking/rwsem-xadd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 1f99664b..6f8bd3c 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -249,8 +249,7 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 {
     if (!(count & RWSEM_ACTIVE_MASK)) {
         /* try acquiring the write lock */
-        if (sem->count == RWSEM_WAITING_BIAS &&
-            cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
+        if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
                 RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
             if (!list_is_singular(&sem->wait_list))
                 rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
-- 
1.9.1
