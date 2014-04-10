Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161275AbaDJNVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:21:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38326 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030855AbaDJNVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:21:30 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-5d-53469ad9d7a2
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, aaro.koskinen@iki.fi,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 13/13] extcon: extcon-max77693: check if pdata exists
Date: Thu, 10 Apr 2014 15:16:51 +0200
Message-id: <1397135811-12866-14-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTYRjHe3euTgeHpXZQDFlJqWUZQS9oZZB2MBLNb5no0sOU3FybWuYH
	l7bCkW1ehmiW07xtTi0vNEWdm5KIlxarTEwLNXOSCqJJNDKn9O33/P+/h+fDQyL8DtSHTJdk
	sTKJMEOAc9GxvwvUyemqqPjT1V0B0LgcAS3dgdDyNR9Obf7AYOniOgJrhicxWKIvQ6D6Zy0G
	1V2X4aDTBGDhy3YcTq7oASyaWESg7fsTHDYMtKCw9lE9Cu291Th8Vq9GYV2jEoGLteMc2DD1
	ngNnHjTjsGl1B4eailYUfhvqIWCbowKFyv5hAg7YnBg0f4iO8GOML4yA+bVVijL2p8Ucpren
	GmM06g3A9FTNEoy+aRNnhrZqUaazOYjpMBThzEpLJcZ8+dSHM+bnRoIpLlzDGUfJH5zp2VYQ
	sZ43uOGpbEZ6Dis7dSGZm2ZeWAFSFXFPsVRGKMAWpgJuJE2dpd845vF99qZtc+27zCX5VB2g
	55WznP3hMYf+aNQjLgunTtBd2xrgYk8KoXXad8AlIdQoRhss5j3pIBVJOypVexJKBdDOesde
	zqOi6FeFvagKkLvn/Onq0nAXuu3G/fYjLuTvbmpbBRrA04EDBuDFSlOk8lsi8ZkQuVAsz5aI
	QlIyxR1g75NLviZgUEAroEgg8OANNkbG8zFhjjxXbAU0iQg8ea+1UfF8Xqow9z4ry0ySZWew
	civwJVHBIZ5FGRbHp0TCLPY2y0pZ2f+WQ7r5KEDiKnFpp8LP23ptIkTceTh5uaQsLtp0XB02
	KkqyJ4pGPO+uj+Vd0Q53Dn4u8EiX5DwMtUnygf+Su26hbc3ZfxPUBV/fGUmIOSeN+W2KvXO+
	YCZYdywpJyFwvC8I0eT5TKy5z5WXrzrGLnpdjVTnHqXtW146fUtN99vpjRhCTAhQeZowNAiR
	yYX/AEJEfkrFAgAA
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds check if pdata is NULL, to avoid NULL pointer dereference
when platform data is not available. After this changes, in described
situation driver will be configured with default values.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-max77693.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 2cd8892..fa8534e 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1210,7 +1210,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 
 
 	/* Initialize MUIC register by using platform data or default data */
-	if (pdata->muic_data) {
+	if (pdata && pdata->muic_data) {
 		init_data = pdata->muic_data->init_data;
 		num_init_data = pdata->muic_data->num_init_data;
 	} else {
-- 
1.7.9.5

