Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3L2Czf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:55:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55107 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752177Ab3L2CKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:06 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.894128643@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 155/185] isdnloop: use strlcpy() instead of strcpy()
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f9a23c84486ed350cce7bb1b2828abd1f6658796 ]

These strings come from a copy_from_user() and there is no way to be
sure they are NUL terminated.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/isdn/isdnloop/isdnloop.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index 509135f..4df80fb 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1083,8 +1083,10 @@ isdnloop_start(isdnloop_card * card, isdnloop_sdef * sdefp)
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
@@ -1097,7 +1099,7 @@ isdnloop_start(isdnloop_card * card, isdnloop_sdef * sdefp)
 				spin_unlock_irqrestore(&card->isdnloop_lock, flags);
 				return -ENOMEM;
 			}
-			strcpy(card->s0num[0], sdef.num[0]);
+			strlcpy(card->s0num[0], sdef.num[0], sizeof(card->s0num[0]));
 			card->s0num[1][0] = '\0';
 			card->s0num[2][0] = '\0';
 			break;

