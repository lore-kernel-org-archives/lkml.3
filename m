Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaJ0Kph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:45:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42872 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaJ0Kpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:45:34 -0400
Date: Mon, 27 Oct 2014 13:45:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] regulator: max77802: fix a test in
 max77802_set_suspend_mode()
Message-ID: <20141027104506.GA22704@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71442C69-B48C-46B8-93A1-068AC26E01C2@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original test triggers a static checker warning.  Javier Martinez
Canillas says that the "!" is a typo and should be removed.

Fixes: 2e0eaa1aa008 ('regulator: max77802: Add set suspend mode for BUCKs and simplify code')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2:  The first version of this patch was buggy.  Thanks Javier for
your review.

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 5839c45..7718c8a 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -179,7 +179,7 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
 	 * If the regulator has been disabled for suspend
 	 * then is invalid to try setting a suspend mode.
 	 */
-	if (!max77802->opmode[id] == MAX77802_OFF_PWRREQ) {
+	if (max77802->opmode[id] == MAX77802_OFF_PWRREQ) {
 		dev_warn(&rdev->dev, "%s: is disabled, mode: 0x%x not set\n",
 			 rdev->desc->name, mode);
 		return 0;
