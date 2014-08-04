Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaHDNC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:02:58 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:41838 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaHDNCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:02:55 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 05/10] staging: ozwpan: Remove dead code
Date: Mon,  4 Aug 2014 14:54:51 +0200
Message-Id: <1407156896-3246-6-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to return a value from elt_buf_init().

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/ozwpan/ozeltbuf.c | 3 +--
 drivers/staging/ozwpan/ozeltbuf.h | 2 +-
 drivers/staging/ozwpan/ozpd.c     | 5 +----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index bd560c6..f6e6481 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -16,7 +16,7 @@
 /*
  * Context: softirq-serialized
  */
-int oz_elt_buf_init(struct oz_elt_buf *buf)
+void oz_elt_buf_init(struct oz_elt_buf *buf)
 {
 	memset(buf, 0, sizeof(struct oz_elt_buf));
 	INIT_LIST_HEAD(&buf->stream_list);
@@ -24,7 +24,6 @@ int oz_elt_buf_init(struct oz_elt_buf *buf)
 	INIT_LIST_HEAD(&buf->isoc_list);
 	buf->max_free_elts = 32;
 	spin_lock_init(&buf->lock);
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/ozwpan/ozeltbuf.h b/drivers/staging/ozwpan/ozeltbuf.h
index 03c12f5..3846432 100644
--- a/drivers/staging/ozwpan/ozeltbuf.h
+++ b/drivers/staging/ozwpan/ozeltbuf.h
@@ -50,7 +50,7 @@ struct oz_elt_buf {
 	u8 tx_seq_num[OZ_NB_APPS];
 };
 
-int oz_elt_buf_init(struct oz_elt_buf *buf);
+void oz_elt_buf_init(struct oz_elt_buf *buf);
 void oz_elt_buf_term(struct oz_elt_buf *buf);
 struct oz_elt_info *oz_elt_info_alloc(struct oz_elt_buf *buf);
 void oz_elt_info_free(struct oz_elt_buf *buf, struct oz_elt_info *ei);
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 10f1b3a..a27c603 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -175,10 +175,7 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
 		oz_pd_set_state(pd, OZ_PD_S_IDLE);
 		pd->max_tx_size = OZ_MAX_TX_SIZE;
 		ether_addr_copy(pd->mac_addr, mac_addr);
-		if (0 != oz_elt_buf_init(&pd->elt_buff)) {
-			kfree(pd);
-			pd = NULL;
-		}
+		oz_elt_buf_init(&pd->elt_buff);
 		spin_lock_init(&pd->tx_frame_lock);
 		INIT_LIST_HEAD(&pd->tx_queue);
 		INIT_LIST_HEAD(&pd->farewell_list);
-- 
1.9.1

