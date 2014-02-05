Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbaBEIlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:41:09 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47648 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaBEIlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:41:06 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, mturquette@linaro.org
Cc: b.brezillon@overkiz.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jason@lakedaemon.net,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 0/4] clk: at91: better support for the PCKs
Date: Wed,  5 Feb 2014 09:37:34 +0100
Message-Id: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serie implements a better support for the Programmable Clocks.
The first two patch are related to changing the rate of the PCKs.
The 3rd patch is a fix to handle properly the PCKRDY interrupt.
The last patch is a small optimzation/simplification of the determine_rate
algorithm for the PCK.

This has been tested on a 9261ek

Boris BREZILLON (2):
  clk: at91: replace prog clk round_rate with determine_rate
  clk: at91: propagate rate change on system clks

Jean-Jacques Hiblot (2):
  clk: at91: fix programmable clk irq handling
  clk: at91: optimization of the determine_rate callback

 drivers/clk/at91/clk-programmable.c | 202 +++++++++++-------------------------
 drivers/clk/at91/clk-system.c       |  77 ++++++++++++--
 2 files changed, 127 insertions(+), 152 deletions(-)

-- 
1.8.5.2

