Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3LPKml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:42:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51604 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab3LPKmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:42:38 -0500
Date: Mon, 16 Dec 2013 13:42:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pinctrl: off by one in msm_config_group_set()
Message-ID: <20131216104222.GA19404@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be ">= ARRAY_SIZE()" instead of "> ARRAY_SIZE()".

Fixes: f365be092572 ('pinctrl: Add Qualcomm TLMM driver')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 28b90aba708d..03c4e615ebb8 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -350,7 +350,7 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
 			break;
 		case PIN_CONFIG_DRIVE_STRENGTH:
 			/* Check for invalid values */
-			if (arg > ARRAY_SIZE(msm_drive_to_regval))
+			if (arg >= ARRAY_SIZE(msm_drive_to_regval))
 				arg = -1;
 			else
 				arg = msm_drive_to_regval[arg];
