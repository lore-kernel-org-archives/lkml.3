Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030209Ab3BAMIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:08:52 -0500
Received: from nbd.name ([46.4.11.11]:41402 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326Ab3BAMIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:08:00 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>,
        Thomas Langer <thomas.langer@lantiq.com>
Subject: [PATCH 08/11] PINCTRL: lantiq: fix pinconfig parameters
Date: Fri,  1 Feb 2013 13:05:02 +0100
Message-Id: <1359720305-31933-8-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Falcon driver only defined the pinconf parameters but did not pass them
properly to the underlying api.

Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-falcon.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index 249a405..c5a9868 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -360,6 +360,8 @@ static const struct ltq_cfg_param falcon_cfg_params[] = {
 static struct ltq_pinmux_info falcon_info = {
 	.desc		= &falcon_pctrl_desc,
 	.apply_mux	= falcon_mux_apply,
+	.params		= falcon_cfg_params,
+	.num_params	= ARRAY_SIZE(falcon_cfg_params),
 };
 
 
-- 
1.7.10.4

