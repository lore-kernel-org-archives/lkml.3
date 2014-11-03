Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaKCP6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:58:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbaKCP55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:57:57 -0500
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, rusty@rustcorp.com.au, herbert@gondor.apana.org.au,
        m@bues.ch, mb@bu3sch.de, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/6] hw_random: don't double-check old_rng.
Date: Mon,  3 Nov 2014 23:56:25 +0800
Message-Id: <1415030186-18303-6-git-send-email-akong@redhat.com>
In-Reply-To: <1415030186-18303-1-git-send-email-akong@redhat.com>
References: <1415030186-18303-1-git-send-email-akong@redhat.com>
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
index c31bf91..fc5de7d 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -480,14 +480,13 @@ int hwrng_register(struct hwrng *rng)
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

