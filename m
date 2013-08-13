Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab3HMQIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:08:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646Ab3HMP6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:30 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=sbfD_COeXY8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=AtHT9ExjPB0A:10 a=YhdJeHolAAAA:8 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155825.398653108@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [11/88] gianfar: add missing iounmap() on error in gianfar_ptp_probe()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0011-gianfar-add-missing-iounmap-on-error-in-gianfar_ptp_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit e5f5e380e0f3bb11f04ca5bc66a551e58e0ad26e ]

Add the missing iounmap() before return from gianfar_ptp_probe()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/freescale/gianfar_ptp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/gianfar_ptp.c b/drivers/net/ethernet/freescale/gianfar_ptp.c
index d81c7af..d98b3f2 100644
--- a/drivers/net/ethernet/freescale/gianfar_ptp.c
+++ b/drivers/net/ethernet/freescale/gianfar_ptp.c
@@ -521,6 +521,7 @@ static int gianfar_ptp_probe(struct platform_device *dev)
 	return 0;
 
 no_clock:
+	iounmap(etsects->regs);
 no_ioremap:
 	release_resource(etsects->rsrc);
 no_resource:
-- 
1.7.10.4


