Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3LDXfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:35:39 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:51142 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3LDXfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:35:36 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/7] Calxeda arm64 clock updates
Date: Wed,  4 Dec 2013 17:35:20 -0600
Message-Id: <1386200127-23143-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series updates the highbank clock code for ECX-3000 series support.     
The primary functional change is making the PLL max frequency a runtime
setting. The rest of the changes are enabling building on arm64 and new
DT bindings.

The patch "clk: highbank: prevent glitching when going into bypass mode"
is a fix needed for ECX-2000 systems and should be applied for 3.13 and
stable.

Rob

Mark Langsdorf (1):
  clk: highbank: prevent glitching when going into bypass mode

Rob Herring (6):
  dt-bindings: add Calxeda ECX-3000 clock binding
  dt-bindings: Add property calxeda,pll-max-hz for Calxeda clocks
  dt-bindings: Add Calxeda system registers binding
  clk: highbank: allow for different PLL frequency range
  clk: highbank: allow enabling by user
  clk: highbank: add DT match for calxeda,ecx-3000-sregs

 .../devicetree/bindings/arm/calxeda/sregs.txt      | 17 +++++++++
 .../devicetree/bindings/clock/calxeda.txt          |  9 ++++-
 arch/arm/mach-highbank/Kconfig                     |  1 +
 drivers/clk/Kconfig                                |  5 +++
 drivers/clk/Makefile                               |  2 +-
 drivers/clk/clk-highbank.c                         | 43 +++++++++++++++-------
 6 files changed, 61 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/calxeda/sregs.txt

-- 
1.8.3.2

