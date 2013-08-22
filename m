Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3HVQTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:19:24 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:45411 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3HVQTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:19:20 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/3] mmc: dw_mmc: Set timeout to max upon resume
Date: Thu, 22 Aug 2013 09:19:08 -0700
Message-Id: <1377188348-3418-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1377188348-3418-1-git-send-email-dianders@chromium.org>
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TMOUT register is initted to 0xffffffff at probe time but isn't
initted after suspend/resume.  Add an init of this value.

No problems were observed without this (it will also get initted in
__dw_mci_start_request if there is data to send), but it makes the
register dump before and after suspend cleaner.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/mmc/host/dw_mmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index f6c7545..6a9a846 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2506,6 +2506,9 @@ int dw_mci_resume(struct dw_mci *host)
 	/* Restore the old value at FIFOTH register */
 	mci_writel(host, FIFOTH, host->fifoth_val);
 
+	/* Put in max timeout */
+	mci_writel(host, TMOUT, 0xFFFFFFFF);
+
 	mci_writel(host, RINTSTS, 0xFFFFFFFF);
 	mci_writel(host, INTMASK, SDMMC_INT_CMD_DONE | SDMMC_INT_DATA_OVER |
 		   SDMMC_INT_TXDR | SDMMC_INT_RXDR |
-- 
1.8.3

