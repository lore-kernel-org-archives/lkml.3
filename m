Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbbAEJJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:09:28 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32361 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbAEJJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:09:25 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-f4-54aa54c4dcff
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] watchdog: imx2: Constify struct regmap_config and watchdog_ops
Date: Mon, 05 Jan 2015 10:09:17 +0100
Message-id: <1420448957-10106-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJMWRmVeSWpSXmKPExsVy+t/xy7pHQlaFGNydrWTx+oWhxeVdc9gs
	bqzbx25xa8YLVgcWj2ubxTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr486jm6wFJzkqJt1g
	b2DsY+9i5OSQEDCR+DxxLiuELSZx4d56ti5GLg4hgaWMEl/3HAVLCAn0MUksPVoEYrMJGEts
	Xr6EDcQWEUiReH7pFSOIzSxgKPHz3R+wocIC/hKLLy1g6mLk4GARUJXY+0UCJMwr4C5x++lE
	qF1yEiePTWadwMi9gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkaIr7/uYFx6zOoQowAH
	oxIPr8eJlSFCrIllxZW5hxglOJiVRHjX3QIK8aYkVlalFuXHF5XmpBYfYmTi4JRqYEw3qpyV
	93Su60od94vHT4gUNipvmOtR1sx6/vu8alfp7zc9TAwWNciHfThmIWNxYVLes23rNqdJsZzd
	n7uC1Vp99jMxpbK/yvv2NOk+ffnfnGlXzT0RFqFMw52/j5tdNDg90d1+u2zIHu+tz/YseDbn
	d+zDywfqwh30I+d9/8+l6LVArOeGqbgSS3FGoqEWc1FxIgBDnpLO0wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make struct
watchdog_ops const as well.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/watchdog/imx2_wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index d6add516a7a7..bdb4dc1a2ee2 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -203,7 +203,7 @@ static inline void imx2_wdt_ping_if_active(struct watchdog_device *wdog)
 	}
 }
 
-static struct watchdog_ops imx2_wdt_ops = {
+static const struct watchdog_ops imx2_wdt_ops = {
 	.owner = THIS_MODULE,
 	.start = imx2_wdt_start,
 	.stop = imx2_wdt_stop,
@@ -211,7 +211,7 @@ static struct watchdog_ops imx2_wdt_ops = {
 	.set_timeout = imx2_wdt_set_timeout,
 };
 
-static struct regmap_config imx2_wdt_regmap_config = {
+static const struct regmap_config imx2_wdt_regmap_config = {
 	.reg_bits = 16,
 	.reg_stride = 2,
 	.val_bits = 16,
-- 
1.9.1

