Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3HPWhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:37:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51471 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab3HPWhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:37:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 128/133] af_key: more info leaks in pfkey messages
Date: Fri, 16 Aug 2013 15:34:30 -0700
Message-Id: <1376692475-28413-129-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ff862a4668dd6dba962b1d2d8bd344afa6375683 ]

This is inspired by a5cc68f3d6 "af_key: fix info leaks in notify
messages".  There are some struct members which don't get initialized
and could disclose small amounts of private information.

Acked-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/key/af_key.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 891db6c..e1cc508 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2076,6 +2076,7 @@ static int pfkey_xfrm_policy2msg(struct sk_buff *skb, const struct xfrm_policy *
 			pol->sadb_x_policy_type = IPSEC_POLICY_NONE;
 	}
 	pol->sadb_x_policy_dir = dir+1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = xp->index;
 	pol->sadb_x_policy_priority = xp->priority;
 
@@ -3111,7 +3112,9 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	pol->sadb_x_policy_exttype = SADB_X_EXT_POLICY;
 	pol->sadb_x_policy_type = IPSEC_POLICY_IPSEC;
 	pol->sadb_x_policy_dir = XFRM_POLICY_OUT + 1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = xp->index;
+	pol->sadb_x_policy_priority = xp->priority;
 
 	/* Set sadb_comb's. */
 	if (x->id.proto == IPPROTO_AH)
@@ -3499,6 +3502,7 @@ static int pfkey_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	pol->sadb_x_policy_exttype = SADB_X_EXT_POLICY;
 	pol->sadb_x_policy_type = IPSEC_POLICY_IPSEC;
 	pol->sadb_x_policy_dir = dir + 1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = 0;
 	pol->sadb_x_policy_priority = 0;
 
-- 
1.8.1.2

