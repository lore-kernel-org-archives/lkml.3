Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbaELB4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:56:18 -0400
Received: from 1wt.eu ([62.212.114.60]:34693 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbaELBnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:12 -0400
Message-Id: <20140512003205.251889846@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 111/143] isdnloop: Validate NUL-terminated strings from user.
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

[ Upstream commit 77bc6bed7121936bb2e019a8c336075f4c8eef62 ]

Return -EINVAL unless all of user-given strings are correctly
NUL-terminated.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/isdn/isdnloop/isdnloop.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index bf4168b..4267d48 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1071,6 +1071,12 @@ isdnloop_start(isdnloop_card * card, isdnloop_sdef * sdefp)
 		return -EBUSY;
 	if (copy_from_user((char *) &sdef, (char *) sdefp, sizeof(sdef)))
 		return -EFAULT;
+
+	for (i = 0; i < 3; i++) {
+		if (!memchr(sdef.num[i], 0, sizeof(sdef.num[i])))
+			return -EINVAL;
+	}
+
 	spin_lock_irqsave(&card->isdnloop_lock, flags);
 	switch (sdef.ptype) {
 		case ISDN_PTYPE_EURO:
-- 
1.7.12.2.21.g234cd45.dirty



