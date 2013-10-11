Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab3JKULb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:11:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab3JKTlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 031/135] net:dccp: do not report ICMP redirects to user space
Date: Fri, 11 Oct 2013 12:38:32 -0700
Message-Id: <20131011193948.604277923@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

[ Upstream commit bd784a140712fd06674f2240eecfc4ccae421129 ]

DCCP shouldn't be setting sk_err on redirects as it
isn't an error condition. it should be doing exactly
what tcp is doing and leaving the error handler without
touching the socket.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dccp/ipv6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -135,6 +135,7 @@ static void dccp_v6_err(struct sk_buff *
 
 		if (dst)
 			dst->ops->redirect(dst, sk, skb);
+		goto out;
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {


