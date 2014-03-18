Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaCRRgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:36:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33679 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175AbaCRRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:36:17 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: arizona: Add MICVDD to mapped regulators
Date: Tue, 18 Mar 2014 17:27:42 +0000
Message-Id: <1395163663-1845-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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

