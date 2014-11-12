Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934962AbaKLD4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:56:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282AbaKLD4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:56:02 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Wed, 12 Nov 2014 14:55:19 +1100
Subject: [PATCH 1/2] mmc: core: use card->ocr when negotiating voltage
 setting in mmc_sdio_power_restore
Cc: GTA04 owners <gta04-owner@goldelico.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141112035519.18267.76525.stgit@notabene.brown>
In-Reply-To: <20141112035217.18267.43304.stgit@notabene.brown>
References: <20141112035217.18267.43304.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we are restoring power to a known card, it makes sense to use
the 'ocr' value known for the card rather than the generic one
for the host interface.
This matches the use of card->ocr passed to mmc_power_up in
mmc_sdio_runtime_resume  (just before mmc_sdio_power_restore is
called), and the value passed to mmc_sdio_init_card() a little
later in mmc_sdio_power_restore().

Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/mmc/core/sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index e636d9e99e4a..3c0f07961fab 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -1028,7 +1028,7 @@ static int mmc_sdio_power_restore(struct mmc_host *host)
 
 	sdio_reset(host);
 	mmc_go_idle(host);
-	mmc_send_if_cond(host, host->ocr_avail);
+	mmc_send_if_cond(host, host->card->ocr);
 
 	ret = mmc_send_io_op_cond(host, 0, NULL);
 	if (ret)


