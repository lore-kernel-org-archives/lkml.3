Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaJXIRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:17:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16738 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaJXIRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:17:11 -0400
Date: Fri, 24 Oct 2014 11:16:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] regulator: max77802: precedence error in
 max77802_set_suspend_mode()
Message-ID: <20141024081646.GB11140@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "!" operation has higher precedence that the comparison.

Fixes: 2e0eaa1aa008 ('regulator: max77802: Add set suspend mode for BUCKs and simplify code')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 5839c45..57e37fd 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -179,7 +179,7 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
 	 * If the regulator has been disabled for suspend
 	 * then is invalid to try setting a suspend mode.
 	 */
-	if (!max77802->opmode[id] == MAX77802_OFF_PWRREQ) {
+	if (max77802->opmode[id] != MAX77802_OFF_PWRREQ) {
 		dev_warn(&rdev->dev, "%s: is disabled, mode: 0x%x not set\n",
 			 rdev->desc->name, mode);
 		return 0;
