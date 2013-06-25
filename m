Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab3FYFC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:02:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18203 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3FYFC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:02:58 -0400
X-AuditID: cbfee691-b7fef6d000002d62-42-51c9247f154b
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: anton.vorontsov@linaro.org
Cc: linux-kernel@vger.kernel.org, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 1/2] power: charger-manager: regulator_get() never returns NULL.
Date: Tue, 25 Jun 2013 14:02:48 +0900
Message-id: <1372136569-551-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWyRsSkWLde5WSgwZFnNhYXW2+zWHSefcJs
	cXnXHDaL240r2BxYPO5c28Pm0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBlfFi1jLDjIXjH7
	5iamBsaVbF2MnBwSAiYS658/ZIWwxSQu3FsPFOfiEBJYyiix5OktVpiiKzNugNlCAosYJR4v
	9YEoamGS6Nn/jBEkwSagI/F/3012EFtEQE7i9dq/TCA2s0CxxOdri8GahQUCJBau2Qq2mUVA
	VWLv/6lgNbwCbhK7dz8BmsMBtExBYs4kG5D5EgK32SQmtT2CqheQ+Db5EAtEjazEpgPMELdJ
	ShxccYNlAqPgAkaGVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiBIXj637OJOxjvH7A+xJgM
	NG4is5Rocj4whPNK4g2NzYwsTE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwBh1xZzTRqlH7djN5J2bv09qmfiU3dFWM/G8bParhuDsp5yfhbrezD5T45a9c/rj
	qwe8maXYVugdzJP6eTzuPItCgaQHW4mJyT5338Zn52rjV/Wv/PySX1y6TlNKqHPz9j9fJErO
	SWlffylYc/L0Z2Xp2vTI7sTjyvov82b5NUt0qcq/d+dUVmIpzkg01GIuKk4EAKzbqrdXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd16lZOBBidWmVlcbL3NYtF59gmz
	xeVdc9gsbjeuYHNg8bhzbQ+bR9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmfFm0jLHgIHvF7JubmBoYV7J1MXJySAiYSFyZcYMVwhaTuHBvPVhcSGAR
	o8TjpT5djFxAdguTRM/+Z4wgCTYBHYn/+26yg9giAnISr9f+ZQKxmQWKJT5fWww2SFggQGLh
	mq1gg1gEVCX2/p8KVsMr4Caxe/cToDkcQMsUJOZMspnAyL2AkWEVo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRnCAP5PewbiqweIQowAHoxIP74e4E4FCrIllxZW5hxglOJiVRHhDRYBCvCmJ
	lVWpRfnxRaU5qcWHGJOBlk9klhJNzgdGX15JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNIT
	S1KzU1MLUotgtjBxcEo1MHquWFc1NeXdl7wXcve//TgmLJo6q+ZDy3yr4LkHvy9VZ9ZZZ5Nv
	yyS5WaRuXSlr0dbbPivEhWcYqOxLK/y7XUpBSqCn6UaosSBHXPWBfhX9h8FxWq4znxrtuugW
	dk1toYC6s9+V+9v3bf4uFpN4+pm2UkP7AX+FNylr/qSUuW+P/nt3m6vhRSWW4oxEQy3mouJE
	ACWV8c20AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes return value checking of regulator_get() in charger-manager
driver. The API, regulator_get(), returns ERR_PTR() when it fails to get
regulator with given name, not NULL.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/charger-manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index ba42029..7d1bcde 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1239,7 +1239,7 @@ static int charger_manager_register_extcon(struct charger_manager *cm)
 
 		charger->consumer = regulator_get(cm->dev,
 					charger->regulator_name);
-		if (charger->consumer == NULL) {
+		if (IS_ERR(charger->consumer)) {
 			dev_err(cm->dev, "Cannot find charger(%s)\n",
 				charger->regulator_name);
 			ret = -EINVAL;
-- 
1.7.9.5

