Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaCKJAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:00:50 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34616 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaCKJAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:00:48 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH v3 0/4] clk: at91: better support for the PCKs
Date: Tue, 11 Mar 2014 10:00:31 +0100
Message-Id: <1394528435-23734-1-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon@overkiz.com>

This serie implements a better support for the Programmable Clocks.
The first two patch are related to changing the rate of the PCKs.
The 3rd patch is a fix to handle properly the PCKRDY interrupt.
The last patch is a small optimzation/simplification of the determine_rate
algorithm for the PCK.

Changes since v2:
- remove unnecessary CLK_SET_RATE_GATE flag from system clk setting

Boris BREZILLON (2):
  clk: at91: replace prog clk round_rate with determine_rate
  clk: at91: propagate rate change on system clks

Jean-Jacques Hiblot (2):
  clk: at91: fix programmable clk irq handling
  clk: at91: optimization of the set_rate callback

 drivers/clk/at91/clk-programmable.c |  202 +++++++++++------------------------
 drivers/clk/at91/clk-system.c       |   76 +++++++++++--
 2 files changed, 126 insertions(+), 152 deletions(-)

-- 
1.7.9.5

