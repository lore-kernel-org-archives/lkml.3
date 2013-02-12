Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab3BLUln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:41:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156Ab3BLUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        nitin padalia <padalia.nitin@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [ 08/36] net: prevent setting ttl=0 via IP_TTL
Date: Tue, 12 Feb 2013 12:41:02 -0800
Message-Id: <20130212203858.304834661@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit c9be4a5c49cf51cc70a993f004c5bb30067a65ce ]

A regression is introduced by the following commit:

	commit 4d52cfbef6266092d535237ba5a4b981458ab171
	Author: Eric Dumazet <eric.dumazet@gmail.com>
	Date:   Tue Jun 2 00:42:16 2009 -0700

	    net: ipv4/ip_sockglue.c cleanups

	    Pure cleanups

but it is not a pure cleanup...

	-               if (val != -1 && (val < 1 || val>255))
	+               if (val != -1 && (val < 0 || val > 255))

Since there is no reason provided to allow ttl=0, change it back.

Reported-by: nitin padalia <padalia.nitin@gmail.com>
Cc: nitin padalia <padalia.nitin@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_sockglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -589,7 +589,7 @@ static int do_ip_setsockopt(struct sock
 	case IP_TTL:
 		if (optlen < 1)
 			goto e_inval;
-		if (val != -1 && (val < 0 || val > 255))
+		if (val != -1 && (val < 1 || val > 255))
 			goto e_inval;
 		inet->uc_ttl = val;
 		break;


