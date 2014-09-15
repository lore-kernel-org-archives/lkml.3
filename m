Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaIOQEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:04:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbaIOQEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:04:05 -0400
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de,
        mpm@selenic.com, rusty@rustcorp.com.au, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] hw_random: increase schedule timeout in rng_dev_read()
Date: Tue, 16 Sep 2014 00:02:29 +0800
Message-Id: <1410796949-2221-4-git-send-email-akong@redhat.com>
In-Reply-To: <1410796949-2221-1-git-send-email-akong@redhat.com>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch increases the schedule timeout to 10 jiffies, it's more
appropriate, then other takes can easy to hold the mutex lock.

Signed-off-by: Amos Kong <akong@redhat.com>
---
 drivers/char/hw_random/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 263a370..b5d1b6f 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -195,7 +195,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 
 		mutex_unlock(&rng_mutex);
 
-		schedule_timeout_interruptible(1);
+		schedule_timeout_interruptible(10);
 
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
-- 
1.9.3

