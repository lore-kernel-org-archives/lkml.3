Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbbAEJM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:12:27 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39513 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbAEJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:44 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-4f-54aa52f590e9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 04/14] mfd: davinci_voicecodec: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:23 +0100
Message-id: <1420448493-9355-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xa7pfg1aFGMxdwGTx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8byFSdYC66y
	Vqw89ZS1gfERSxcjJ4eEgInE9wO/GSFsMYkL99azdTFycQgJLGWU+LTwGFhCSKCPSeLQU1MQ
	m03AWGLz8iVsILaIQJbEj2mrwQYxCxhK/Hz3hx3EFhbwlehfuw4sziKgKrHt539mEJtXwE3i
	4crtbBDL5CROHpvM2sXIwcEp4C5x+3EkiCkEVPLvbcIERt4FjAyrGEVTS5MLipPScw31ihNz
	i0vz0vWS83M3MUJC5MsOxsXHrA4xCnAwKvHwepxYGSLEmlhWXJl7iFGCg1lJhHfdLaAQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGxvSZ5h/0zs3sKumX1UsyPsBr2eH0ddUz6byiq0wbXQP2OPzT
	Pfrq8JyzZrmbalt5LVNM5ixediT5p7yCwmI3t8S433kM+9+bfD755pnSDW67S2fnKSR1b2wX
	n1al+t25yrokdtLBwjXn6x0jFPe/bl4+Q5M97WNg9R8rw6/ro59/5mq+oMnersRSnJFoqMVc
	VJwIADWarYvvAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/davinci_voicecodec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index c835e85539b2..9bbc642a7b9d 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -33,7 +33,7 @@
 
 #include <linux/mfd/davinci_voicecodec.h>
 
-static struct regmap_config davinci_vc_regmap = {
+static const struct regmap_config davinci_vc_regmap = {
 	.reg_bits = 32,
 	.val_bits = 32,
 };
-- 
1.9.1

