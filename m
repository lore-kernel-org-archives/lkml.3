Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaBUIHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:07:34 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7570 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbaBUIHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:07:33 -0500
From: Nenghua Cao <nhcao@marvell.com>
To: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC: Nenghua Cao <nhcao@marvell.com>
Subject: [PATCH 1/2] driver: regmap: fix coccinelle warnings
Date: Fri, 21 Feb 2014 16:05:45 +0800
Message-ID: <1392969945-28004-1-git-send-email-nhcao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-21_03:2014-02-21,2014-02-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402200242
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nenghua Cao <nhcao@marvell.com>

   /drivers/base/regmap/regmap.c:717:6-33: WARNING:
Comparison to bool.

   More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Nenghua Cao <nhcao@marvell.com>
---
 drivers/base/regmap/regmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 4b2ed0c..78fc54c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -718,7 +718,7 @@ skip_format_initialization:
 		new->window_start = range_cfg->window_start;
 		new->window_len = range_cfg->window_len;
 
-		if (_regmap_range_add(map, new) == false) {
+		if (!_regmap_range_add(map, new)) {
 			dev_err(map->dev, "Failed to add range %d\n", i);
 			kfree(new);
 			goto err_range;
-- 
1.7.0.4

