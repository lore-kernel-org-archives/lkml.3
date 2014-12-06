Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaLFERA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:17:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaLFEQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:16:56 -0500
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au
Cc: kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: [PATCH v5 5/6] hw_random: don't double-check old_rng.
Date: Sat,  6 Dec 2014 12:16:41 +0800
Message-Id: <1417839402-13490-6-git-send-email-akong@redhat.com>
In-Reply-To: <1417839402-13490-1-git-send-email-akong@redhat.com>
References: <1417839402-13490-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Interesting anti-pattern.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 067270b..a9286bf 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -476,14 +476,13 @@ int hwrng_register(struct hwrng *rng)
 	}
 
 	old_rng = current_rng;
+	err = 0;
 	if (!old_rng) {
 		err = hwrng_init(rng);
 		if (err)
 			goto out_unlock;
 		set_current_rng(rng);
-	}
-	err = 0;
-	if (!old_rng) {
+
 		err = register_miscdev();
 		if (err) {
 			drop_current_rng();
-- 
1.9.3

