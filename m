Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3IISrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:47:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57144 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3IISrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:47:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 23/24] af_key: initialize satype in key_notify_policy_flush()
Date: Mon,  9 Sep 2013 11:45:13 -0700
Message-Id: <1378752314-2416-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 85dfb745ee40232876663ae206cba35f24ab2a40 upstream.

This field was left uninitialized. Some user daemons perform check against this
field.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/key/af_key.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index e1cc508..2c698fc 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2690,6 +2690,7 @@ static int key_notify_policy_flush(const struct km_event *c)
 	hdr->sadb_msg_pid = c->portid;
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
+	hdr->sadb_msg_satype = SADB_SATYPE_UNSPEC;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
 	hdr->sadb_msg_reserved = 0;
 	pfkey_broadcast(skb_out, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);
-- 
1.8.1.2

