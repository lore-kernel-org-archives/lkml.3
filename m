Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaLHIxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:53:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbaLHIvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:51:37 -0500
From: Amos Kong <akong@redhat.com>
To: linux-crypto@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, herbert@gondor.apana.org.au,
        rusty@rustcorp.com.au, kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH v5 REPOST 5/6] hw_random: don't double-check old_rng.
Date: Mon,  8 Dec 2014 16:50:39 +0800
Message-Id: <1418028640-4891-6-git-send-email-akong@redhat.com>
In-Reply-To: <1418028640-4891-1-git-send-email-akong@redhat.com>
References: <1418028640-4891-1-git-send-email-akong@redhat.com>
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

