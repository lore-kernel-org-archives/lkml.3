Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbaIRMi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:38:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbaIRMiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:38:25 -0400
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch,
        mpm@selenic.com, amit.shah@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] hw_random: don't init list element we're about to add to list.
Date: Thu, 18 Sep 2014 20:37:47 +0800
Message-Id: <1411043867-21109-7-git-send-email-akong@redhat.com>
In-Reply-To: <1411043867-21109-1-git-send-email-akong@redhat.com>
References: <1411043867-21109-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Another interesting anti-pattern.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 6420409..12187dd 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -486,7 +486,6 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 		}
 	}
-	INIT_LIST_HEAD(&rng->list);
 	list_add_tail(&rng->list, &rng_list);
 
 	if (old_rng && !rng->init) {
-- 
1.9.3

