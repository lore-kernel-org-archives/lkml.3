Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaCJQ3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:29:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42836 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaCJQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:29:46 -0400
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Mon, 10 Mar 2014 16:29:37 +0000
Message-Id: <1394468977-23149-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.9.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm5102: Mark register 0x19 readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

During init the core checks if the wm5102 has finished starting by reading
register 0x19 and looking at the value. This read always fails since this
is not a readable register, mark it as being one.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/wm5102-tables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index f4668d39e542..07f024fd4ded 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1016,6 +1016,7 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_WRITE_SEQUENCER_CTRL_0:
 	case ARIZONA_WRITE_SEQUENCER_CTRL_1:
 	case ARIZONA_WRITE_SEQUENCER_CTRL_2:
+	case 0x19:
 	case ARIZONA_WRITE_SEQUENCER_PROM:
 	case ARIZONA_TONE_GENERATOR_1:
 	case ARIZONA_TONE_GENERATOR_2:
-- 
1.9.0

