Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaLNUcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:32:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaLNUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wolfgang Walter <linux@stwm.de>, Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 24/34] gre: Set inner mac header in gro complete
Date: Sun, 14 Dec 2014 12:21:02 -0800
Message-Id: <20141214201804.495790049@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201803.791392744@linuxfoundation.org>
References: <20141214201803.791392744@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Herbert <therbert@google.com>

[ Upstream commit 6fb2a756739aa507c1fd5b8126f0bfc2f070dc46 ]

Set the inner mac header to point to the GRE payload when
doing GRO. This is needed if we proceed to send the packet
through GRE GSO which now uses the inner mac header instead
of inner network header to determine the length of encapsulation
headers.

Fixes: 14051f0452a2 ("gre: Use inner mac length when computing tunnel length")
Reported-by: Wolfgang Walter <linux@stwm.de>
Signed-off-by: Tom Herbert <therbert@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/gre_offload.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -271,6 +271,9 @@ static int gre_gro_complete(struct sk_bu
 		err = ptype->callbacks.gro_complete(skb, nhoff + grehlen);
 
 	rcu_read_unlock();
+
+	skb_set_inner_mac_header(skb, nhoff + grehlen);
+
 	return err;
 }
 


