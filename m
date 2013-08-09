Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967406Ab3HIBmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:42:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967120Ab3HIBl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:41:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 21/22] af_key: more info leaks in pfkey messages
Date: Thu,  8 Aug 2013 18:41:37 -0700
Message-Id: <20130809013953.833985235@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809013949.226228694@linuxfoundation.org>
References: <20130809013949.226228694@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/key/af_key.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2073,6 +2073,7 @@ static int pfkey_xfrm_policy2msg(struct
 			pol->sadb_x_policy_type = IPSEC_POLICY_NONE;
 	}
 	pol->sadb_x_policy_dir = dir+1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = xp->index;
 	pol->sadb_x_policy_priority = xp->priority;
 
@@ -3108,7 +3109,9 @@ static int pfkey_send_acquire(struct xfr
 	pol->sadb_x_policy_exttype = SADB_X_EXT_POLICY;
 	pol->sadb_x_policy_type = IPSEC_POLICY_IPSEC;
 	pol->sadb_x_policy_dir = dir+1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = xp->index;
+	pol->sadb_x_policy_priority = xp->priority;
 
 	/* Set sadb_comb's. */
 	if (x->id.proto == IPPROTO_AH)
@@ -3496,6 +3499,7 @@ static int pfkey_send_migrate(const stru
 	pol->sadb_x_policy_exttype = SADB_X_EXT_POLICY;
 	pol->sadb_x_policy_type = IPSEC_POLICY_IPSEC;
 	pol->sadb_x_policy_dir = dir + 1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = 0;
 	pol->sadb_x_policy_priority = 0;
 


