Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3H2Qj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:39:26 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45202 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3H2QjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:39:19 -0400
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
Subject: [PATCH v7 3/3] mmc: dw_mmc: Set timeout to max upon resume
Date: Thu, 29 Aug 2013 09:39:10 -0700
Message-Id: <1377794350-12335-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1377794350-12335-1-git-send-email-dianders@chromium.org>
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
 <1377794350-12335-1-git-send-email-dianders@chromium.org>
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
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/mmc/host/dw_mmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 1584705..f8d891a 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2513,6 +2513,9 @@ int dw_mci_resume(struct dw_mci *host)
 	/* Restore the old value at FIFOTH register */
 	mci_writel(host, FIFOTH, host->fifoth_val);
 
+	/* Put in max timeout */
+	mci_writel(host, TMOUT, 0xFFFFFFFF);
+
 	mci_writel(host, RINTSTS, 0xFFFFFFFF);
 	mci_writel(host, INTMASK, SDMMC_INT_CMD_DONE | SDMMC_INT_DATA_OVER |
 		   SDMMC_INT_TXDR | SDMMC_INT_RXDR |
-- 
1.8.4

