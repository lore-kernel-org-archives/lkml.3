Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbaIRCwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:52:08 -0400
Received: from ozlabs.org ([103.22.144.67]:49243 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004AbaIRCwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:52:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amos Kong <akong@redhat.com>, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch,
        mb@bu3sch.de, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/5] hw_random: don't init list element we're about to add to list.
Date: Thu, 18 Sep 2014 12:18:26 +0930
Message-Id: <1411008506-28349-5-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411008506-28349-1-git-send-email-rusty@rustcorp.com.au>
References: <87wq91odhf.fsf@rustcorp.com.au>
 <1411008506-28349-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another interesting anti-pattern.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 6a34feca6b43..96fa06716e95 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -485,7 +485,6 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 		}
 	}
-	INIT_LIST_HEAD(&rng->list);
 	list_add_tail(&rng->list, &rng_list);
 
 	if (old_rng && !rng->init) {
-- 
1.9.1

