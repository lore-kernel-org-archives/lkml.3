Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaCRK6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:58:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42385 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755040AbaCRK6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:58:02 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] mfd: arizona: Add MICVDD to mapped regulators
Date: Tue, 18 Mar 2014 10:49:15 +0000
Message-Id: <1395139757-6907-7-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
index 0bab354..06e3f1b 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -589,6 +589,7 @@ static const char *wm5102_supplies[] = {
 	"CPVDD",
 	"SPKVDDL",
 	"SPKVDDR",
+	"MICVDD",
 };
 
 static const struct mfd_cell wm5102_devs[] = {
-- 
1.7.2.5

