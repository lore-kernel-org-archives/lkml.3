Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162057Ab3LFWRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:17:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab3LFVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 15/58] isdnloop: use strlcpy() instead of strcpy()
Date: Fri,  6 Dec 2013 13:51:46 -0800
Message-Id: <20131206214846.333547233@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f9a23c84486ed350cce7bb1b2828abd1f6658796 ]

These strings come from a copy_from_user() and there is no way to be
sure they are NUL terminated.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/isdnloop/isdnloop.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1083,8 +1083,10 @@ isdnloop_start(isdnloop_card *card, isdn
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
@@ -1097,7 +1099,7 @@ isdnloop_start(isdnloop_card *card, isdn
 			spin_unlock_irqrestore(&card->isdnloop_lock, flags);
 			return -ENOMEM;
 		}
-		strcpy(card->s0num[0], sdef.num[0]);
+		strlcpy(card->s0num[0], sdef.num[0], sizeof(card->s0num[0]));
 		card->s0num[1][0] = '\0';
 		card->s0num[2][0] = '\0';
 		break;


