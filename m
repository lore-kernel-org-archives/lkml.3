Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967770AbaLLMf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:35:56 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59632 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966556AbaLLMfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:35:54 -0500
Date: Fri, 12 Dec 2014 13:35:52 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Guo-Fu Tseng <cooldavid@cooldavid.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] jme: replace calls to redundant function
Message-ID: <20141212123552.GA12787@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calls to tasklet_hi_enable are replaced by calls to
tasklet_enable since the 2 functions are redundant.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
---
 drivers/net/ethernet/jme.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 4a1be34..44ce7d8 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -1364,8 +1364,8 @@ err_out_free_rx_resources:
 	jme_free_rx_resources(jme);
 out_enable_tasklet:
 	tasklet_enable(&jme->txclean_task);
-	tasklet_hi_enable(&jme->rxclean_task);
-	tasklet_hi_enable(&jme->rxempty_task);
+	tasklet_enable(&jme->rxclean_task);
+	tasklet_enable(&jme->rxempty_task);
 out:
 	atomic_inc(&jme->link_changing);
 }
@@ -2408,8 +2408,8 @@ static inline void jme_resume_rx(struct jme_adapter *jme)
 	if (test_bit(JME_FLAG_POLL, &jme->flags)) {
 		JME_NAPI_ENABLE(jme);
 	} else {
-		tasklet_hi_enable(&jme->rxclean_task);
-		tasklet_hi_enable(&jme->rxempty_task);
+		tasklet_enable(&jme->rxclean_task);
+		tasklet_enable(&jme->rxempty_task);
 	}
 	dpi->cur		= PCC_P1;
 	dpi->attempt		= PCC_P1;
@@ -3290,8 +3290,8 @@ jme_suspend(struct device *dev)
 	}
 
 	tasklet_enable(&jme->txclean_task);
-	tasklet_hi_enable(&jme->rxclean_task);
-	tasklet_hi_enable(&jme->rxempty_task);
+	tasklet_enable(&jme->rxclean_task);
+	tasklet_enable(&jme->rxempty_task);
 
 	jme_powersave_phy(jme);
 
-- 
1.9.1

