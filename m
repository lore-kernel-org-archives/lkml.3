Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab3IBJNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:13:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261Ab3IBIyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:54:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 05/58] af_key: initialize satype in key_notify_policy_flush()
Date: Mon,  2 Sep 2013 09:53:50 +0100
Message-Id: <1378112083-9475-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 85dfb745ee40232876663ae206cba35f24ab2a40 upstream.

This field was left uninitialized. Some user daemons perform check against this
field.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/key/af_key.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 7dcb525..b606ce5 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2687,6 +2687,7 @@ static int key_notify_policy_flush(const struct km_event *c)
 	hdr->sadb_msg_pid = c->pid;
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
+	hdr->sadb_msg_satype = SADB_SATYPE_UNSPEC;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
 	hdr->sadb_msg_reserved = 0;
 	pfkey_broadcast(skb_out, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);
-- 
1.8.3.2

