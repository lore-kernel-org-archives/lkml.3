Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab3CTPTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:19:50 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55851 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab3CTPTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:19:47 -0400
Date: Wed, 20 Mar 2013 08:19:24 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <samuel@sortiz.org>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Brad Spengler <spender@grsecurity.net>
Subject: [PATCH] net/irda: add missing error path release_sock call
Message-ID: <20130320151924.GA4955@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure that release_sock is called for all error conditions in
irda_getsockopt.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Brad Spengler <spender@grsecurity.net>
Cc: stable@vger.kernel.org
---
 net/irda/af_irda.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index d07e3a6..d28e7f0 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -2583,8 +2583,10 @@ bed:
 				    NULL, NULL, NULL);
 
 		/* Check if the we got some results */
-		if (!self->cachedaddr)
-			return -EAGAIN;		/* Didn't find any devices */
+		if (!self->cachedaddr) {
+			err = -EAGAIN;		/* Didn't find any devices */
+			goto out;
+		}
 		daddr = self->cachedaddr;
 		/* Cleanup */
 		self->cachedaddr = 0;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
