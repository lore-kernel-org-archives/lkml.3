Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaDUVRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:17:06 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:37816 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaDUVRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:17:02 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 RESEND 0/7] clk: bcm281xx: updates
Date: Mon, 21 Apr 2014 16:11:36 -0500
Message-Id: <1398114703-32410-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series includes updates for the bcm281xx clock code.  It is
dependent on the following patch, which has been taken into the
clk-fixes tree:
    clk: bcm281xx: don't use unnamed structs or unions
    https://lkml.org/lkml/2014/4/7/322

There are three groups of patches:
    - Some straightforward code cleanups
    - Changing CCU and clock definitions so they're almost
      completely initialized statically (i.e., not at run-time)
    - Add two small features

Initially this series included support for "prerequisite clocks"
but that has been removed so it can be discussed independently.

The patches in this series--based on the current linus/master branch
plus the patch mentioned above--are available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/bcm-clk-next-v4

    					-Alex

History:
  - v4: Rebased on current linus/master and reworked to account
  	for the no-longer-unnamed union and struct members.
  - v3: Dropped prerequisite clock support so resolving how
	best to handle that can be resolved separately.  As
	a result, bus clock support is no longer included.
  - v2: Removed one unrelated patch from the series.

Alex Elder (7):
  clk: bcm281xx: warn if ccu_wait_bit() fails
  clk: bcm281xx: use init_data.name for clock name
  clk: bcm281xx: change some symbol names
  clk: bcm281xx: initialize CCU structures statically
  clk: bcm281xx: define CCU clock data statically
  clk: bcm281xx: add clock policy support
  clk: bcm281xx: add clock hysteresis support

 drivers/clk/bcm/clk-bcm281xx.c   | 243 +++++++++++++++++----------------------
 drivers/clk/bcm/clk-kona-setup.c | 229 ++++++++++++++++++++++++++----------
 drivers/clk/bcm/clk-kona.c       | 212 ++++++++++++++++++++++++++++++++--
 drivers/clk/bcm/clk-kona.h       | 160 +++++++++++++++++++++-----
 4 files changed, 611 insertions(+), 233 deletions(-)

-- 
1.9.1

