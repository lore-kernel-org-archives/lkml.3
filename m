Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaIRCxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:53:16 -0400
Received: from ozlabs.org ([103.22.144.67]:49256 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbaIRCwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:52:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amos Kong <akong@redhat.com>, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch,
        mb@bu3sch.de, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/5] hw_random: don't double-check old_rng.
Date: Thu, 18 Sep 2014 12:18:25 +0930
Message-Id: <1411008506-28349-4-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411008506-28349-1-git-send-email-rusty@rustcorp.com.au>
References: <87wq91odhf.fsf@rustcorp.com.au>
 <1411008506-28349-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting anti-pattern.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index b4a21e9521cf..6a34feca6b43 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -472,14 +472,13 @@ int hwrng_register(struct hwrng *rng)
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
1.9.1

