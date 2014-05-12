Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaELCCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:02:20 -0400
Received: from 1wt.eu ([62.212.114.60]:34607 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaELBmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:42 -0400
Message-Id: <20140512003203.834362862@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 077/143] isdnloop: use strlcpy() instead of strcpy()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f9a23c84486ed350cce7bb1b2828abd1f6658796 ]

These strings come from a copy_from_user() and there is no way to be
sure they are NUL terminated.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/isdn/isdnloop/isdnloop.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index 22446f7..92d895f 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1082,8 +1082,10 @@ isdnloop_start(isdnloop_card * card, isdnloop_sdef * sdefp)
 				spin_unlock_irqrestore(&card->isdnloop_lock, flags);
 				return -ENOMEM;
 			}
-			for (i = 0; i < 3; i++)
-				strcpy(card->s0num[i], sdef.num[i]);
+			for (i = 0; i < 3; i++) {
+				strlcpy(card->s0num[i], sdef.num[i],
+					sizeof(card->s0num[0]));
+			}
 			break;
 		case ISDN_PTYPE_1TR6:
 			if (isdnloop_fake(card, "DRV1.04TC-1TR6-CAPI-CNS-BASIS-29.11.95",
@@ -1096,7 +1098,7 @@ isdnloop_start(isdnloop_card * card, isdnloop_sdef * sdefp)
 				spin_unlock_irqrestore(&card->isdnloop_lock, flags);
 				return -ENOMEM;
 			}
-			strcpy(card->s0num[0], sdef.num[0]);
+			strlcpy(card->s0num[0], sdef.num[0], sizeof(card->s0num[0]));
 			card->s0num[1][0] = '\0';
 			card->s0num[2][0] = '\0';
 			break;
-- 
1.7.12.2.21.g234cd45.dirty



