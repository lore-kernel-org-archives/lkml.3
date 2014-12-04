Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaLDKKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:10:04 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:37323 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaLDKKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:10:00 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <441b4a042bbbcbdcea4b745efd721b00>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com,
        Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v17 10/12] drm: bridge/dw_hdmi: add function dw_hdmi_phy_enable_spare
Date: Thu,  4 Dec 2014 18:09:33 +0800
Message-Id: <1417687773-13394-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
References: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RK3288 HDMI will not work without the spare bit of
HDMI_PHY_CONF0 enable

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
---

Changes in v17: None
Changes in v16: None
Changes in v15: None
Changes in v14: None
Changes in v13: None
Changes in v12: None
Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None

 drivers/gpu/drm/bridge/dw_hdmi.c | 7 +++++++
 drivers/gpu/drm/bridge/dw_hdmi.h | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index 93bf5ca..5ec337e 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -713,6 +713,13 @@ static void dw_hdmi_phy_enable_tmds(struct dw_hdmi *hdmi, u8 enable)
 			 HDMI_PHY_CONF0_ENTMDS_MASK);
 }
 
+static void dw_hdmi_phy_enable_spare(struct dw_hdmi *hdmi, u8 enable)
+{
+	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
+			 HDMI_PHY_CONF0_SPARECTRL_OFFSET,
+			 HDMI_PHY_CONF0_SPARECTRL_MASK);
+}
+
 static void dw_hdmi_phy_gen2_pddq(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
diff --git a/drivers/gpu/drm/bridge/dw_hdmi.h b/drivers/gpu/drm/bridge/dw_hdmi.h
index baa7849..175dbc8 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.h
+++ b/drivers/gpu/drm/bridge/dw_hdmi.h
@@ -837,7 +837,8 @@ enum {
 	HDMI_PHY_CONF0_PDZ_OFFSET = 7,
 	HDMI_PHY_CONF0_ENTMDS_MASK = 0x40,
 	HDMI_PHY_CONF0_ENTMDS_OFFSET = 6,
-	HDMI_PHY_CONF0_SPARECTRL = 0x20,
+	HDMI_PHY_CONF0_SPARECTRL_MASK = 0x20,
+	HDMI_PHY_CONF0_SPARECTRL_OFFSET = 5,
 	HDMI_PHY_CONF0_GEN2_PDDQ_MASK = 0x10,
 	HDMI_PHY_CONF0_GEN2_PDDQ_OFFSET = 4,
 	HDMI_PHY_CONF0_GEN2_TXPWRON_MASK = 0x8,
-- 
1.9.1


