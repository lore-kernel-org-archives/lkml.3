Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbaGEMaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:30:39 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39233 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbaGEMai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:30:38 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: msm: mddi.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:31:54 +0200
Message-Id: <1404563514-20355-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/msm/mddi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/msm/mddi.c b/drivers/video/fbdev/msm/mddi.c
index e0f8011..d65ff75a 100644
--- a/drivers/video/fbdev/msm/mddi.c
+++ b/drivers/video/fbdev/msm/mddi.c
@@ -257,12 +257,12 @@ static irqreturn_t mddi_isr(int irq, void *data)
 	struct msm_mddi_client_data *cdata = data;
 	struct mddi_info *mddi = container_of(cdata, struct mddi_info,
 					      client_data);
-	uint32_t active, status;
+	uint32_t active;
 
 	spin_lock(&mddi->int_lock);
 
 	active = mddi_readl(INT);
-	status = mddi_readl(STAT);
+	mddi_readl(STAT);
 
 	mddi_writel(active, INT);
 
@@ -548,7 +548,6 @@ uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
 	struct mddi_llentry *ll;
 	struct mddi_register_access *ra;
 	struct reg_read_info ri;
-	unsigned s;
 	int retry_count = 2;
 	unsigned long irq_flags;
 
@@ -572,7 +571,7 @@ uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
 	ll->next = 0;
 	ll->reserved = 0;
 
-	s = mddi_readl(STAT);
+	mddi_readl(STAT);
 
 	ri.reg = reg;
 	ri.status = -1;
-- 
1.7.10.4

