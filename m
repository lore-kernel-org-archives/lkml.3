Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaEVSsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:48:55 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54935 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaEVSsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:48:53 -0400
Date: Thu, 22 May 2014 11:48:41 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Fariya Fatima <fariyaf@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] rsi: avoid format string leak to thread name
Message-ID: <20140522184841.GA8625@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the rsi_create_kthread interface does not include any format
string arguments, make sure that the resulting thread name can never
accidentally process the name as a format string.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/rsi/rsi_common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index f2f70784d4ad..d3fbe33d2324 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -63,7 +63,7 @@ static inline int rsi_create_kthread(struct rsi_common *common,
 				     u8 *name)
 {
 	init_completion(&thread->completion);
-	thread->task = kthread_run(func_ptr, common, name);
+	thread->task = kthread_run(func_ptr, common, "%s", name);
 	if (IS_ERR(thread->task))
 		return (int)PTR_ERR(thread->task);
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
