Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3BDMGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:06:37 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33479 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3BDL5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Alexandre Torgue <alexandre.torgue@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 42/73] regulator: ab8500: Correct init mask for AB8540
Date: Mon,  4 Feb 2013 11:53:57 +0000
Message-Id: <1359978868-28736-43-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@stericsson.com>

Start-up initialisation values for AB8540_REGUSYSCLKREQVALID1 and
AB8540_REGUSYSCLKREQVALID2 are currently slightly incorrect. This
patch ensures they are set at their correct values.

Signed-off-by: Alexandre Torgue <alexandre.torgue@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/regulator/ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index f27b398..1f1f361 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2249,13 +2249,13 @@ static struct ab8500_reg_init ab8540_reg_init[] = {
 	 * ...
 	 * 0x80, SysClkReq8Valid1
 	 */
-	REG_INIT(AB8540_REGUSYSCLKREQVALID1,	0x03, 0x0f, 0xfe),
+	REG_INIT(AB8540_REGUSYSCLKREQVALID1,	0x03, 0x0f, 0xff),
 	/*
 	 * 0x02, SysClkReq2Valid2
 	 * ...
 	 * 0x80, SysClkReq8Valid2
 	 */
-	REG_INIT(AB8540_REGUSYSCLKREQVALID2,	0x03, 0x10, 0xfe),
+	REG_INIT(AB8540_REGUSYSCLKREQVALID2,	0x03, 0x10, 0xff),
 	/*
 	 * 0x01, Vaux4SwHPReqValid
 	 * 0x02, Vaux4HwHPReq2Valid
-- 
1.7.9.5

