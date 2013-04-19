Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030546Ab3DSMdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:33:52 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48042 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968311Ab3DSMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:33:51 -0400
Message-ID: <1366374825.4345.1.camel@phoenix>
Subject: [PATCH] regulator: palmas: Add missing ctrl_addr setting for SMPS10
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Apr 2013 20:33:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ctrl_addr setting for SMPS10 is missed, thus palmas_smps_init() read/write
wrong register for SMPS10 in current code. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 67ed5e5d..9254f94 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -99,6 +99,7 @@ static const struct regs_info palmas_regs_info[] = {
 	{
 		.name		= "SMPS10",
 		.sname		= "smps10-in",
+		.ctrl_addr	= PALMAS_SMPS10_CTRL,
 	},
 	{
 		.name		= "LDO1",
-- 
1.7.10.4



