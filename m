Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3IKEab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3IKE3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:05 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=IdinYms2iJ0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=DC-vBZZrH5MA:10 a=YhdJeHolAAAA:8 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042859.089054044@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [041/251] l2tp: add missing .owner to struct pppox_proto
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0041-l2tp-add-missing-.owner-to-struct-pppox_proto.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit e1558a93b61962710733dc8c11a2bc765607f1cd ]

Add missing .owner of struct pppox_proto. This prevents the
module from being removed from underneath its users.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/l2tp/l2tp_ppp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 955195c..feca60c 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1837,7 +1837,8 @@ static const struct proto_ops pppol2tp_ops = {
 
 static const struct pppox_proto pppol2tp_proto = {
 	.create		= pppol2tp_create,
-	.ioctl		= pppol2tp_ioctl
+	.ioctl		= pppol2tp_ioctl,
+	.owner		= THIS_MODULE,
 };
 
 #ifdef CONFIG_L2TP_V3
-- 
1.7.10.4


