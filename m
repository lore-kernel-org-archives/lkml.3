Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaBEVAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:00:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:54669 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaBEUFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:18 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 069/213] xfrm_user: fix info leak in copy_to_user_policy()
Date: Wed, 5 Feb 2014 15:00:24 -0500
Message-ID: <1391630568-49251-70-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7b789836f434c87168eab067cfbed1ec4783dffd upstream.

The memory reserved to dump the xfrm policy includes multiple padding
bytes added by the compiler for alignment (padding bytes in struct
xfrm_selector and struct xfrm_userpolicy_info). Add an explicit
memset(0) before filling the buffer to avoid the heap info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index a0039040aba6..2f72480e6b8d 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1200,6 +1200,7 @@ static void copy_from_user_policy(struct xfrm_policy *xp, struct xfrm_userpolicy
 
 static void copy_to_user_policy(struct xfrm_policy *xp, struct xfrm_userpolicy_info *p, int dir)
 {
+	memset(p, 0, sizeof(*p));
 	memcpy(&p->sel, &xp->selector, sizeof(p->sel));
 	memcpy(&p->lft, &xp->lft, sizeof(p->lft));
 	memcpy(&p->curlft, &xp->curlft, sizeof(p->curlft));
-- 
1.8.5.2

