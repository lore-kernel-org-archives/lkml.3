Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaGTFSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 01:18:04 -0400
Received: from m12-14.163.com ([220.181.12.14]:50465 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbaGTFSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 01:18:02 -0400
X-Coremail-DSSMTP: 180.110.162.144
From: weiyj_lk@163.com
To: Sebastian Reichel <sre@kernel.org>, Tom Gundersen <teg@jklm.no>,
        Carlos Chinea <carlos.chinea@nokia.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH -next] HSI: ssi_protocol: Fix sparse non static symbol warning
Date: Sun, 20 Jul 2014 13:17:20 +0800
Message-Id: <1405833440-6731-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DsCowECpXUXnUMtT8H3_CA--.413S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGw4UtFyDJr4xGw43GFg_yoWfJFc_AF
	yYqF9rWr4UZasYkasY9Fyrtr1fGr4F9FnYkFn8tFy3A397A3sxArnrJ3y7A3WYqF4DXFWk
	twnYgwn5Ars3ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYVuWJUUUUU==
X-Originating-IP: [180.110.162.144]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/xtbBDRrO1lIwSgqRfgABsD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/hsi/clients/ssi_protocol.c:904:6: warning:
 symbol 'ssip_port_event' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hsi/clients/ssi_protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 737fa2e..e5c7a96 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -901,7 +901,7 @@ out:
 	ssip_free_data(msg);
 }
 
-void ssip_port_event(struct hsi_client *cl, unsigned long event)
+static void ssip_port_event(struct hsi_client *cl, unsigned long event)
 {
 	switch (event) {
 	case HSI_EVENT_START_RX:

