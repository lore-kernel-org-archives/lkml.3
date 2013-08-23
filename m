Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3HWLfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:35:52 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55599 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3HWLfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:35:36 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org,
        linus.walleij@linaro.org
Subject: [PATCH 2/2] mfd: db8500-prcmu: Staticize clk_mgt
Date: Fri, 23 Aug 2013 17:05:20 +0530
Message-Id: <1377257720-15861-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1377257720-15861-1-git-send-email-sachin.kamat@linaro.org>
References: <1377257720-15861-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_mgt is used only in this file. Make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 8685872..53f371d 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -465,7 +465,7 @@ static DEFINE_SPINLOCK(clk_mgt_lock);
 
 #define CLK_MGT_ENTRY(_name, _branch, _clk38div)[PRCMU_##_name] = \
 	{ (PRCM_##_name##_MGT), 0 , _branch, _clk38div}
-struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
+static struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
 	CLK_MGT_ENTRY(SGACLK, PLL_DIV, false),
 	CLK_MGT_ENTRY(UARTCLK, PLL_FIX, true),
 	CLK_MGT_ENTRY(MSP02CLK, PLL_FIX, true),
-- 
1.7.4.1

