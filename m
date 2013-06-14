Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3FNPnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:43:24 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34453 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3FNPnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:43:23 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/5] pinctrl: handle zero found dt pinconfig properties better
Date: Fri, 14 Jun 2013 17:43:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201306141741.46077.heiko@sntech.de>
In-Reply-To: <201306141741.46077.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306141743.21365.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a shortcut when no valid pinconf properties are found
in the parsed dt node, to set the values immediately and return.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/pinctrl/pinconf-generic.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index dcf0371..ea9da17 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -208,6 +208,13 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 		ncfg++;
 	}
 
+	/* no configs found at all */
+	if (ncfg == 0) {
+		*configs = NULL;
+		*nconfigs = 0;
+		return 0;
+	}
+
 	/*
 	 * Now limit the number of configs to the real number of
 	 * found properties.
-- 
1.7.10.4

