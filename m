Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbaESQnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:43:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52619 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbaESQnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:43:11 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/3] mfd: arizona: Add MICVDD to mapped regulators
Date: Mon, 19 May 2014 17:35:27 +0100
Message-Id: <1400517329-1103-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, MICVDD only binds because it is both the regulator name and
the consumer name and we will always match against the regulator name
regardless of the consumer device. If the regulator was renamed using
the init_data ASoC will no longer be able to locate the supply, as it
will be looking on the CODEC device where as the MICVDD consumer is on
the Arizona device. Add a mapping as we do for the other regulators.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index a45aab9..a068748 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -575,6 +575,7 @@ static const char *wm5102_supplies[] = {
 	"CPVDD",
 	"SPKVDDL",
 	"SPKVDDR",
+	"MICVDD",
 };
 
 static const struct mfd_cell wm5102_devs[] = {
-- 
1.7.2.5

