Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3JAPeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:34:01 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63542 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3JAPdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:33:54 -0400
Message-ID: <1380641628.19681.3.camel@phoenix>
Subject: [RFT][PATCH 1/2] regulator: as3722: Fix equation to calculate
 max_uV in regulator_lin_range macro
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Florian Lobmaier <florian.lobmaier@ams.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 01 Oct 2013 23:33:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix off-by-one in the equation to calculate max_uV.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
I don't have the datasheet and h/w.
Just found this issue while reading the code. (Only compile test).

Axel
 drivers/regulator/as3722-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index 16a5d26..c6a1fc6 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -441,7 +441,7 @@ static struct regulator_ops as3722_ldo3_extcntrl_ops = {
 		.max_sel = _max_sel,					\
 		.uV_step = _step_uV,					\
 		.min_uV = _min_uV,					\
-		.max_uV = _min_uV + (_max_sel - _min_sel + 1) * _step_uV, \
+		.max_uV = _min_uV + (_max_sel - _min_sel) * _step_uV,	\
 	}
 
 static const struct regulator_linear_range as3722_ldo_ranges[] = {
-- 
1.8.1.2



