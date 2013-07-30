Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab3G3JtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:49:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53161 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab3G3JdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 052/106] l2tp: add missing .owner to struct pppox_proto
Date: Tue, 30 Jul 2013 10:31:11 +0100
Message-Id: <1375176725-5825-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit e1558a93b61962710733dc8c11a2bc765607f1cd upstream.

Add missing .owner of struct pppox_proto. This prevents the
module from being removed from underneath its users.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/l2tp/l2tp_ppp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index ea7e244..286fec4 100644
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
1.8.3.2

