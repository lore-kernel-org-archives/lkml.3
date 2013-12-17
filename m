Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3LQSN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:13:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab3LQSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:13:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 008/103] isdnloop: use strlcpy() instead of strcpy()
Date: Tue, 17 Dec 2013 18:11:57 +0000
Message-Id: <1387304012-23805-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f9a23c84486ed350cce7bb1b2828abd1f6658796 upstream.

These strings come from a copy_from_user() and there is no way to be
sure they are NUL terminated.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/isdn/isdnloop/isdnloop.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index baf2686..02125e6 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1083,8 +1083,10 @@ isdnloop_start(isdnloop_card *card, isdnloop_sdef *sdefp)
 			spin_unlock_irqrestore(&card->isdnloop_lock, flags);
 			return -ENOMEM;
 		}
-		for (i = 0; i < 3; i++)
-			strcpy(card->s0num[i], sdef.num[i]);
+		for (i = 0; i < 3; i++) {
+			strlcpy(card->s0num[i], sdef.num[i],
+				sizeof(card->s0num[0]));
+		}
 		break;
 	case ISDN_PTYPE_1TR6:
 		if (isdnloop_fake(card, "DRV1.04TC-1TR6-CAPI-CNS-BASIS-29.11.95",
@@ -1097,7 +1099,7 @@ isdnloop_start(isdnloop_card *card, isdnloop_sdef *sdefp)
 			spin_unlock_irqrestore(&card->isdnloop_lock, flags);
 			return -ENOMEM;
 		}
-		strcpy(card->s0num[0], sdef.num[0]);
+		strlcpy(card->s0num[0], sdef.num[0], sizeof(card->s0num[0]));
 		card->s0num[1][0] = '\0';
 		card->s0num[2][0] = '\0';
 		break;
-- 
1.8.3.2

