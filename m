Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaLFERG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:17:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaLFERE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:17:04 -0500
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au
Cc: kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: [PATCH v5 6/6] hw_random: don't init list element we're about to add to list.
Date: Sat,  6 Dec 2014 12:16:42 +0800
Message-Id: <1417839402-13490-7-git-send-email-akong@redhat.com>
In-Reply-To: <1417839402-13490-1-git-send-email-akong@redhat.com>
References: <1417839402-13490-1-git-send-email-akong@redhat.com>
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
index a9286bf..4d13ac5 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -489,7 +489,6 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 		}
 	}
-	INIT_LIST_HEAD(&rng->list);
 	list_add_tail(&rng->list, &rng_list);
 
 	if (old_rng && !rng->init) {
-- 
1.9.3

