Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab3DBWMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:12:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761197Ab3DBWMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Brad Spengler <spender@grsecurity.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 040/124] net/irda: add missing error path release_sock call
Date: Tue,  2 Apr 2013 15:10:22 -0700
Message-Id: <20130402221108.854105153@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 896ee0eee6261e30c3623be931c3f621428947df upstream.

This makes sure that release_sock is called for all error conditions in
irda_getsockopt.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/irda/af_irda.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -2584,8 +2584,10 @@ bed:
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


