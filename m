Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab3HRU2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:28:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3HRU2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:28:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [ 03/12] af_key: initialize satype in key_notify_policy_flush()
Date: Sun, 18 Aug 2013 13:30:12 -0700
Message-Id: <20130818202950.443321529@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818202949.875887601@linuxfoundation.org>
References: <20130818202949.875887601@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 85dfb745ee40232876663ae206cba35f24ab2a40 upstream.

This field was left uninitialized. Some user daemons perform check against this
field.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/key/af_key.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2687,6 +2687,7 @@ static int key_notify_policy_flush(const
 	hdr->sadb_msg_pid = c->pid;
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
+	hdr->sadb_msg_satype = SADB_SATYPE_UNSPEC;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
 	hdr->sadb_msg_reserved = 0;
 	pfkey_broadcast(skb_out, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);


