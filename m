Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964854AbaFIPEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:04:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54942 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964810AbaFIPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:04:45 -0400
Date: Mon, 9 Jun 2014 16:04:35 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] regulator: arizona-ldo1: Do not control clocking from
	regulator
Message-ID: <20140609150435.GE5229@opensource.wolfsonmicro.com>
References: <20140609150013.GA5229@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609150013.GA5229@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the driver for the internal regulator to also control
the clock frequency of blocks inside the codec is an
unexpected side-effect for a regulator, and also means that
the core clocks won't be changed as expected if an external
regulator is used to power the codec.

The clocking control is now handled by the core arizona MFD
driver so can be removed from the LDO1 driver.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index d3787e1..ea4fbce 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -77,11 +77,6 @@ static int arizona_ldo1_hc_set_voltage_sel(struct regulator_dev *rdev,
 	if (ret != 0)
 		return ret;
 
-	ret = regmap_update_bits(regmap, ARIZONA_DYNAMIC_FREQUENCY_SCALING_1,
-				 ARIZONA_SUBSYS_MAX_FREQ, val);
-	if (ret != 0)
-		return ret;
-
 	if (val)
 		return 0;
 
-- 
1.7.2.5


