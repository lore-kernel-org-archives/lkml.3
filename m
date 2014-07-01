Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaGAVJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:09:06 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3856 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaGAVJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:09:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 01 Jul 2014 14:02:29 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Felipe Balbi <balbi@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tuomas.tynkkynen@iki.fi>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 1/3] reset: Re-export of_reset_control_get
Date: Wed, 2 Jul 2014 00:08:41 +0300
Message-ID: <1404248923-21086-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404248923-21086-1-git-send-email-ttynkkynen@nvidia.com>
References: <1404248923-21086-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b424080a9e086e683ad5fdc624a7cf3c024e0c0f (reset: Add optional
resets and stubs) accidentally dropped the declaration of
of_reset_control_get from include/linux/reset.h. Add it back to the
header.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 include/linux/reset.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index 349f150..cfc8de8 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -13,6 +13,8 @@ int reset_control_deassert(struct reset_control *rstc);
 
 struct reset_control *reset_control_get(struct device *dev, const char *id);
 void reset_control_put(struct reset_control *rstc);
+struct reset_control *of_reset_control_get(struct device_node *node,
+					   const char *id);
 struct reset_control *devm_reset_control_get(struct device *dev, const char *id);
 
 int __must_check device_reset(struct device *dev);
@@ -73,6 +75,12 @@ static inline struct reset_control *reset_control_get_optional(
 	return ERR_PTR(-ENOSYS);
 }
 
+static inline struct reset_control *of_reset_control_get(struct device_node *np,
+							 const char *id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline struct reset_control *devm_reset_control_get_optional(
 					struct device *dev, const char *id)
 {
-- 
1.8.1.5

