Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaAHNz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:55:59 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56167 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbaAHNsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:48:53 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v4 18/37] mtd: st_spi_fsm: Prepare read/write sequences according to configuration
Date: Wed,  8 Jan 2014 13:47:01 +0000
Message-Id: <1389188840-14306-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
References: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly we search for our preference read/write configuration based on a
given chip's capabilities. Then we actually set up the message sequence
accordingly.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 02718ae..fc23354 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -649,6 +649,23 @@ static void stfsm_prepare_rw_seq(struct stfsm *fsm,
 	seq->seq[i++] = STFSM_INST_STOP;
 }
 
+static int stfsm_search_prepare_rw_seq(struct stfsm *fsm,
+				       struct stfsm_seq *seq,
+				       struct seq_rw_config *cfgs)
+{
+	struct seq_rw_config *config;
+
+	config = stfsm_search_seq_rw_configs(fsm, cfgs);
+	if (!config) {
+		dev_err(fsm->dev, "failed to find suitable config\n");
+		return -EINVAL;
+	}
+
+	stfsm_prepare_rw_seq(fsm, seq, config);
+
+	return 0;
+}
+
 static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 {
 	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
-- 
1.8.3.2

