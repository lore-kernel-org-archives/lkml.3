Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbbAEJBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:01:48 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31337 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbbAEJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:44 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-59-54aa52f7f2a2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 11/14] mfd: tps65217: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:30 +0100
Message-id: <1420448493-9355-11-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xa7rfg1aFGHy5xG7x+oWhxf2vRxkt
	Lu+aw2Yxe0k/i8XpblaL/Ve8HNg8vn2dxOJx59oeNo95JwM9+rasYvT4vEkugDWKyyYlNSez
	LLVI3y6BK+PY+SOMBRvYKs69vsbcwLietYuRk0NCwETi3bSjjBC2mMSFe+vZuhi5OIQEljJK
	PLhxCsrpY5I4ef4oG0gVm4CxxOblS8BsEYEsiR/TVrN0MXJwMAsUSrQ8jAIJCws4S0w/fgJs
	KIuAqsT5BwfAbF4Bd4kpd+ayQCyTkzh5bDIrSCsnUPz240gQU0jATeLf24QJjLwLGBlWMYqm
	liYXFCel5xrqFSfmFpfmpesl5+duYoSEz5cdjIuPWR1iFOBgVOLh9TixMkSINbGsuDL3EKME
	B7OSCO+6W0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjKUbjX+38S4P+tBjFCvd68q1csMjtcN8
	vSrS2vv8T+/9ybQwsJL7XtWxCu5HAV53v637ckhnevUkZq0Wl0yG94/FTk+21Vaa+TYzkONh
	wEJx33JL27dFTdfXd3IdXVf0m2nxv6gPPT5nzLSPfV4x8chJndx3OqEPQ3Of6Cb6TRfgOh7u
	lq3/U4mlOCPRUIu5qDgRACSaMB39AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
---
 drivers/mfd/tps65217.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 80a919a8ca97..7d1cfc1d3ce0 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -145,7 +145,7 @@ int tps65217_clear_bits(struct tps65217 *tps, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(tps65217_clear_bits);
 
-static struct regmap_config tps65217_regmap_config = {
+static const struct regmap_config tps65217_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-- 
1.9.1

