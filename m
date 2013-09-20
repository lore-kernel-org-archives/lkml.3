Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3ITMIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:08:54 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1742 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3ITMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:08:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 20 Sep 2013 05:08:49 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <broonie@kernel.org>,
        <linus.walleij@linaro.org>, <akpm@linux-foundation.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <rob@landley.net>, <ijc+devicetree@hellion.org.uk>,
        <grant.likely@linaro.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/5] regmap: add helper macro to set min/max range of register
Date: Fri, 20 Sep 2013 18:00:10 +0530
Message-ID: <1379680214-9143-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
References: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper macro to set the min and max value of the register range.

This is useful when initialising the register ranges of the device like

static const struct regmap_range readable_ranges[] = {
	regmap_reg_range(DEVICE_REG0, DEVICE_REG10),
};

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
As per Mark's comment on V1 series, adding the macro in header in place
of defining in driver.
This should go on same tree as 2/5.

 include/linux/regmap.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4c8c20a..047e8dc 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -70,6 +70,8 @@ struct regmap_range {
 	unsigned int range_max;
 };
 
+#define regmap_reg_range(low, high) { .range_min = low, .range_max = high, }
+
 /*
  * A table of ranges including some yes ranges and some no ranges.
  * If a register belongs to a no_range, the corresponding check function
-- 
1.7.1.1

