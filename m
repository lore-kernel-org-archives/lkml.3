Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab3BXPgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 10:36:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58809 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229Ab3BXPgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 10:36:53 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: vinod.koul@intel.com
Cc: kernel@pengutronix.de, jon-hunter@ti.com, djbw@fb.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH] DMA: of: Constant names
Date: Sun, 24 Feb 2013 16:36:09 +0100
Message-Id: <1361720169-3832-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No DMA of-function alters the name, so this patch changes the name arguments
to be constant. Most drivers will probably request DMA channels using a
constant name.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/dma/dmaengine.c   | 2 +-
 drivers/dma/of-dma.c      | 6 +++---
 include/linux/dmaengine.h | 4 ++--
 include/linux/of_dma.h    | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 242b8c0..779f43a 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -555,7 +555,7 @@ EXPORT_SYMBOL_GPL(__dma_request_channel);
  * @dev:	pointer to client device structure
  * @name:	slave channel name
  */
-struct dma_chan *dma_request_slave_channel(struct device *dev, char *name)
+struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name)
 {
 	/* If device-tree is present get slave info from here */
 	if (dev->of_node)
diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 69d04d2..6036cd0 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -172,8 +172,8 @@ EXPORT_SYMBOL_GPL(of_dma_controller_free);
  * specifiers, matches the name provided. Returns 0 if the name matches and
  * a valid pointer to the DMA specifier is found. Otherwise returns -ENODEV.
  */
-static int of_dma_match_channel(struct device_node *np, char *name, int index,
-				struct of_phandle_args *dma_spec)
+static int of_dma_match_channel(struct device_node *np, const char *name,
+				int index, struct of_phandle_args *dma_spec)
 {
 	const char *s;
 
@@ -198,7 +198,7 @@ static int of_dma_match_channel(struct device_node *np, char *name, int index,
  * Returns pointer to appropriate dma channel on success or NULL on error.
  */
 struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
-					      char *name)
+					      const char *name)
 {
 	struct of_phandle_args	dma_spec;
 	struct of_dma		*ofdma;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index f593999..f062f89 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -968,7 +968,7 @@ enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
 struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
-struct dma_chan *dma_request_slave_channel(struct device *dev, char *name);
+struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name);
 void dma_release_channel(struct dma_chan *chan);
 #else
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
@@ -984,7 +984,7 @@ static inline struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask,
 	return NULL;
 }
 static inline struct dma_chan *dma_request_slave_channel(struct device *dev,
-							 char *name)
+							 const char *name)
 {
 	return NULL;
 }
diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
index d15073e..ce6a8ab 100644
--- a/include/linux/of_dma.h
+++ b/include/linux/of_dma.h
@@ -40,7 +40,7 @@ extern int of_dma_controller_register(struct device_node *np,
 		void *data);
 extern int of_dma_controller_free(struct device_node *np);
 extern struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
-						     char *name);
+						     const char *name);
 extern struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
 		struct of_dma *ofdma);
 #else
@@ -58,7 +58,7 @@ static inline int of_dma_controller_free(struct device_node *np)
 }
 
 static inline struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
-						     char *name)
+						     const char *name)
 {
 	return NULL;
 }
-- 
1.8.1.2

