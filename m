Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3FYSoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:44:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3FYSjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:39:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 05/17] gianfar: add missing iounmap() on error in gianfar_ptp_probe()
Date: Tue, 25 Jun 2013 11:39:20 -0700
Message-Id: <20130625183916.086758273@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183915.443950649@linuxfoundation.org>
References: <20130625183915.443950649@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit e5f5e380e0f3bb11f04ca5bc66a551e58e0ad26e ]

Add the missing iounmap() before return from gianfar_ptp_probe()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gianfar_ptp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/gianfar_ptp.c
+++ b/drivers/net/gianfar_ptp.c
@@ -521,6 +521,7 @@ static int gianfar_ptp_probe(struct plat
 	return 0;
 
 no_clock:
+	iounmap(etsects->regs);
 no_ioremap:
 	release_resource(etsects->rsrc);
 no_resource:


