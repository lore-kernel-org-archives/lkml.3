Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3CNIV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:21:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26024 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3CNIVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:21:54 -0400
X-AuditID: cbfee68e-b7f946d000001e37-a2-514188a1e43f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 22/30] rtc: rtc-rv3029c2: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:21:53 +0900
Message-id: <009901ce208c$fbe45ac0$f3ad1040$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAZVRg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zY92FHY6BBr9Xa1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8Xf3VuaC41wVzVvfsDQwXuHoYuTgkBAwkXj2P6eLkRPIFJO4cG89WxcjF4eQwDJG
	iaavK9kgEiYSrQ+2M0EkpjNKfN02lxHC+cUo0fD0GxNIFZuAmsSXL4fZQaaKCOhLtLVogNQw
	C/QySpzp3Q0WFxKwlbj+3w7E5BSwk9iwXgykU1jAQ2L6sl6gCnYOFgFViX0hIAW8QLVrzoWD
	FPAKCEr8mHyPBcRmFtCSWL/zOBOELS+xec1bZohH1CUe/dUFCYsIGEmcO7GMFaJERGLfi3dg
	50oI3GOXaNt1EOwpFgEBiW+TD7FA9MpKbDrADPGrpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUC
	RpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCHx2beD8eYB60OMyUDrJzJLiSbnA+M7ryTe
	0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MtnWfHGrk
	t/HbTYxu1rn2qVxUJMt42YlZbFXKzommgvMEijp2XuWemunD+dJ6w87/q86eqxIMLpjLpM/4
	X94v2S+r0d7A9tWphnsH/x32Ee6bW/PSav4TXcfTOrcnW4XfW7298/76b+LG99/P9bKWXr+v
	PO2r5/F9lkZHdjCJn12xsuBKZexGJZbijERDLeai4kQAIpxxe+UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQd2FHY6BBksWqFksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPF391bmguNcFc1b37A0MF7h6GLk5JAQMJFo
	fbCdCcIWk7hwbz1bFyMXh5DAdEaJr9vmMkI4vxglGp5+A6tiE1CT+PLlMHsXIweHiIC+RFuL
	BkgNs0Avo8SZ3t1gcSEBW4nr/+1ATE4BO4kN68VAOoUFPCSmL+sFqmDnYBFQldgXAlLAC1S7
	5lw4SAGvgKDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZQYplxBQl3j0VxckLCJgJHHuxDJWiBIR
	iX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwfH/
	TGoH48oGi0OMAhyMSjy8B/odAoVYE8uKK3MPMUpwMCuJ8Hp6OQYK8aYkVlalFuXHF5XmpBYf
	YkwG+nIis5Rocj4wNeWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsT
	B6dUA2PN9M0mHDZqPBfOm61KLZqVc53ZQCI3g+f2ga0N01UM1JMmdb/tjp3mdFXug1xKf3Cm
	wub1jvWLDc0mFfyL7pNSnMnUdMFKO0psgea97m9dfzwe6e5PDFeYLyjNtqn4rOjtB1panLvc
	Al8KHLqw3MsqYdeFBxNKNZwDWw/u0Jmypmf6mifx4UosxRmJhlrMRcWJANJHdftDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rv3029c2.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-rv3029c2.c b/drivers/rtc/rtc-rv3029c2.c
index f8ee8ad..5032c24 100644
--- a/drivers/rtc/rtc-rv3029c2.c
+++ b/drivers/rtc/rtc-rv3029c2.c
@@ -395,9 +395,8 @@ static int rv3029c2_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_EMUL))
 		return -ENODEV;
 
-	rtc = rtc_device_register(client->name,
-				&client->dev, &rv3029c2_rtc_ops,
-				THIS_MODULE);
+	rtc = devm_rtc_device_register(&client->dev, client->name,
+					&rv3029c2_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -407,23 +406,14 @@ static int rv3029c2_probe(struct i2c_client *client,
 	rc = rv3029c2_i2c_get_sr(client, buf);
 	if (rc < 0) {
 		dev_err(&client->dev, "reading status failed\n");
-		goto exit_unregister;
+		return rc;
 	}
 
 	return 0;
-
-exit_unregister:
-	rtc_device_unregister(rtc);
-
-	return rc;
 }
 
 static int rv3029c2_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	rtc_device_unregister(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


