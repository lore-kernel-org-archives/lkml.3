Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3KSRQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:16:16 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29802 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3KSRQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:16:10 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-a9-528b9cd89205
From: Tomasz Figa <t.figa@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH] pinctrl: samsung: Allow pin value to be initialized using
 pinfunc.
Date: Tue, 19 Nov 2013 18:15:51 +0100
Message-id: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.8.4.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Vd0bc7qDDNYuFreYf+Qcq8XZZQfZ
	LP4/es1q0bvgKpvF2aY37BZT/ixnstj0+BqrxeVdc9gsZpzfx2Sx9shddotXB9tYLNbPeM1i
	cWzGEkYHXo/ZDRdZPO5c28PmsXlJvUffllWMHtuvzWP2+LxJzmPj3NAA9igum5TUnMyy1CJ9
	uwSujJmz17MX/OKp6Gxewd7A+Jeri5GDQ0LARGLh37guRk4gU0ziwr31bF2MXBxCAksZJZ6f
	3AXl9DFJdO25yghSxSagJvG54REbiC0ioCExpesxO0gRs8ATZom1G14xgySEBUIlPj16xg5i
	swioSvxb384EYvMKOEnM/trLArFOQWLzpEvMExi5FzAyrGIUTS1NLihOSs810itOzC0uzUvX
	S87P3cQICbmvOxiXHrM6xCjAwajEwzvRvStIiDWxrLgy9xCjBAezkghvTX13kBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQbGswHHQxbtVV2x3cpv65//a3Q7ZkiyevhdPLb8+uXi+wbVXavKRd3S
	jqzlebFVPjdK2fmFgbvMP9WNJT1BmVEdUcGi6RfeMfusWt2S/+ZS8wq3+nJFHUH5bN1r9sfT
	921ZJG65dE/nhf9sb2qbdLnfruR/tcq9rt+P79lsprKegk2KC04cndCvxFKckWioxVxUnAgA
	vhizFBcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the range of settings configurable via pinfunc API
to cover pin value as well. This allows configuration of default values
of pins.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt | 1 +
 drivers/pinctrl/pinctrl-samsung.c                             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
index fe34cbb..ed4cc9c 100644
--- a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
@@ -74,6 +74,7 @@ Required Properties:
   "samsung,pins" property of the child node. The following pin configuration
   properties are supported.
 
+  - samsung,pin-val: Initial value of pin output buffer.
   - samsung,pin-pud: Pull up/down configuration.
   - samsung,pin-drv: Drive strength configuration.
   - samsung,pin-pud-pdn: Pull up/down configuration in power down mode.
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index c752de4..6b2194a 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -47,6 +47,7 @@ static struct pin_config {
 	{ "samsung,pin-drv", PINCFG_TYPE_DRV },
 	{ "samsung,pin-con-pdn", PINCFG_TYPE_CON_PDN },
 	{ "samsung,pin-pud-pdn", PINCFG_TYPE_PUD_PDN },
+	{ "samsung,pin-val", PINCFG_TYPE_DAT },
 };
 
 /* Global list of devices (struct samsung_pinctrl_drv_data) */
-- 
1.8.4.2

