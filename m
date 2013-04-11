Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841Ab3DKVGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:06:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935715Ab3DKUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:14 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=fE-4b5MsTyoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Z2F-dvNzFuIA:10 a=cm27Pg_UAAAA:8 a=XxtmG6sFAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=d6PR83jvDpYA:10 a=zIJohssenScA:10 a=zv9_9hqRWm8A:10 a=NuBSTLBdITsA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202603.488914004@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 105/171 ] net/irda: add missing error path release_sock call
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0105-net-irda-add-missing-error-path-release_sock-call.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 896ee0eee6261e30c3623be931c3f621428947df ]

This makes sure that release_sock is called for all error conditions in
irda_getsockopt.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Brad Spengler <spender@grsecurity.net>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/irda/af_irda.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index bb738c9..73dfe2c 100644
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
-- 
1.7.10.4


