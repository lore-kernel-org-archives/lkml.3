Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592AbbA2Ck4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:40:56 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:50399 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbbA2Cky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:40:54 -0500
X-Greylist: delayed 2926 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2015 21:40:54 EST
Date: Wed, 28 Jan 2015 22:15:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] regulator: qcom-rpm: signedness bug in probe()
Message-ID: <20150128191531.GD10259@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"force_mode" is a u32 so it is never "< 0", but because of type
promotion then comparing "== -1" will do what we want.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index edd0a17..ec540aa 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -769,7 +769,7 @@ static int rpm_reg_probe(struct platform_device *pdev)
 			break;
 		}
 
-		if (force_mode < 0) {
+		if (force_mode == -1) {
 			dev_err(&pdev->dev, "invalid force mode\n");
 			return -EINVAL;
 		}
