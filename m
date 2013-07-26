Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab3GZVm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:42:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3GZUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 11/79] l2tp: add missing .owner to struct pppox_proto
Date: Fri, 26 Jul 2013 13:47:01 -0700
Message-Id: <20130726204723.128197533@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit e1558a93b61962710733dc8c11a2bc765607f1cd ]

Add missing .owner of struct pppox_proto. This prevents the
module from being removed from underneath its users.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1793,7 +1793,8 @@ static const struct proto_ops pppol2tp_o
 
 static const struct pppox_proto pppol2tp_proto = {
 	.create		= pppol2tp_create,
-	.ioctl		= pppol2tp_ioctl
+	.ioctl		= pppol2tp_ioctl,
+	.owner		= THIS_MODULE,
 };
 
 #ifdef CONFIG_L2TP_V3


