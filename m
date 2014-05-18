Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaEREAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 00:00:18 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52126 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaEREAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 00:00:13 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH 2/2] staging: slicoss: remove slic_reg_params struct
Date: Sat, 17 May 2014 21:00:04 -0700
Message-Id: <1400385604-21086-3-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uninitialized struct that is only used to regulate whether
incorrect eeprom checksums are ignored.

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
 drivers/staging/slicoss/slic.h    | 7 -------
 drivers/staging/slicoss/slicoss.c | 3 +--
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/slicoss/slic.h b/drivers/staging/slicoss/slic.h
index 0dc73d5..3a5aa88 100644
--- a/drivers/staging/slicoss/slic.h
+++ b/drivers/staging/slicoss/slic.h
@@ -362,12 +362,6 @@ struct slic_shmem {
 	volatile struct slic_stats     inicstats;
 };
 
-struct slic_reg_params {
-	u32       linkspeed;
-	u32       linkduplex;
-	u32       fail_on_bad_eeprom;
-};
-
 struct slic_upr {
 	uint               adapter;
 	u32            upr_request;
@@ -492,7 +486,6 @@ struct adapter {
 	u32             intagg_period;
 	struct inicpm_state    *inicpm_info;
 	void *pinicpm_info;
-	struct slic_reg_params   reg_params;
 	struct slic_ifevents  if_events;
 	struct slic_stats        inicstats_prev;
 	struct slicnet_stats     slic_stats;
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index d3fe8a7..1dae641 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2876,8 +2876,7 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 				    sizeof(struct slic_eeprom),
 				    peeprom, phys_config);
 
-		if ((!card->config.EepromValid) &&
-		    (adapter->reg_params.fail_on_bad_eeprom)) {
+		if (!card->config.EepromValid) {
 			slic_reg64_write(adapter, &slic_regs->slic_isp, 0,
 					 &slic_regs->slic_addr_upper,
 					 0, FLUSH);
-- 
1.9.2

