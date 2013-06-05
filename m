Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab3FEVql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:46:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab3FEVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 093/127] regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10
Date: Wed,  5 Jun 2013 14:34:20 -0700
Message-Id: <20130605213228.516621132@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

commit f232168df0c7e7414b70ac5d8fed83086d441c0b upstream.

regulator_enable_regmap() uses enable_reg to enable the regulator.
But enable_reg for smps10 points to SMPS10_STATUS which is a
read-only register. Fixed the same by having enable_reg
set to SMPS10_CTRL.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/palmas-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -677,7 +677,7 @@ static int palmas_probe(struct platform_
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_STATUS);
+							PALMAS_SMPS10_CTRL);
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;


