Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaFEEUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaFEEUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li RongQing <roy.qing.li@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 031/214] ipv4: initialise the itag variable in __mkroute_input
Date: Wed,  4 Jun 2014 21:16:34 -0700
Message-Id: <20140605041644.042829517@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit fbdc0ad095c0a299e9abf5d8ac8f58374951149a ]

the value of itag is a random value from stack, and may not be initiated by
fib_validate_source, which called fib_combine_itag if CONFIG_IP_ROUTE_CLASSID
is not set

This will make the cached dst uncertainty

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2129,7 +2129,7 @@ static int __mkroute_input(struct sk_buf
 	struct in_device *out_dev;
 	unsigned int flags = 0;
 	__be32 spec_dst;
-	u32 itag;
+	u32 itag = 0;
 
 	/* get a working reference to the output device */
 	out_dev = __in_dev_get_rcu(FIB_RES_DEV(*res));


