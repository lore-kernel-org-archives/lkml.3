Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548Ab3IDJbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:31:31 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9899 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205Ab3IDJba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:31:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Sep 2013 02:31:29 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <axel.lin@ingics.com>, <kishon@ti.com>,
        <gg@slimlogic.co.uk>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: palmas: fix the n_voltages for smps to 122
Date: Wed, 4 Sep 2013 15:20:06 +0530
Message-ID: <1378288206-20741-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the following change
---------
commit ad02e846878ca35e9d3fa584be8ee770e9e14fce
Author: Axel Lin <axel.lin@ingics.com>

    regulator: palmas: Return raw register values as the selectors in [get|set]_voltage_sel

    Don't adjust the selector in [get|set]_voltage_sel, fix it in list_voltage() instead.

    For smps*(except smps10), the vsel reg-value and voltage mapping as below:
----------
The list_voltage() takes the true value of selector which is
programmed in the register.  As per smsp voltage table
    reg-value       volt (uV) ( Assume RANGE is x1 )
    0               0
    1               500000
    2               500000
    3               500000
    4               500000
    5               500000
    6               500000 (0.49V + 1 * 0.01V) * RANGE
    7               510000 (0.49V + 2 * 0.01V) * RANGE
    8               520000 (0.49V + 3 * 0.01V) * RANGE
    9               530000 (0.49V + 4 * 0.01V) * RANGE
    ....
    121            1650000 (0.49V + 116 * 0.1) * RANGE

Hence making n_voltages for smps to 122.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/palmas-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 488dfe7..cb65c6f 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -207,7 +207,7 @@ static unsigned int palmas_smps_ramp_delay[4] = {0, 10000, 5000, 2500};
  *
  * So they are basically (maxV-minV)/stepV
  */
-#define PALMAS_SMPS_NUM_VOLTAGES	117
+#define PALMAS_SMPS_NUM_VOLTAGES	122
 #define PALMAS_SMPS10_NUM_VOLTAGES	2
 #define PALMAS_LDO_NUM_VOLTAGES		50
 
-- 
1.7.1.1

