Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967810AbaLLMg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:36:58 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64873 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967592AbaLLMg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:36:56 -0500
Date: Fri, 12 Dec 2014 13:36:54 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Guo-Fu Tseng <cooldavid@cooldavid.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] linux/interrupt.h: remove the definition of unused
 tasklet_hi_enable
Message-ID: <20141212123654.GA12811@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
---
 include/linux/interrupt.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 69517a2..d9b05b5 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -556,12 +556,6 @@ static inline void tasklet_enable(struct tasklet_struct *t)
 	atomic_dec(&t->count);
 }
 
-static inline void tasklet_hi_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic();
-	atomic_dec(&t->count);
-}
-
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
-- 
1.9.1

