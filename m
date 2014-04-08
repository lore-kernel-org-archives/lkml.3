Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbaDHVnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:43:14 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44572 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727AbaDHVnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:43:12 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/7] clk: bcm281xx: updates
Date: Tue,  8 Apr 2014 16:43:38 -0500
Message-Id: <1396993425-30683-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
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
       	Three small code improvements.

  clk: bcm281xx: initialize CCU structures statically
  clk: bcm281xx: define CCU clock data statically
	Rearrange the way CCUs and the clocks they provide are
	defined, so that they're defined statically to the extent
	possible rather than allocating and initializing things at
	runtime.

  clk: bcm281xx: add clock policy support
  clk: bcm281xx: add clock hysteresis support
	Add two new features, ultimately for the eventual purpose of
	adding support for another type of Kona clock.

 drivers/clk/bcm/clk-bcm281xx.c   |  243 +++++++++++++++++---------------------
 drivers/clk/bcm/clk-kona-setup.c |  229 +++++++++++++++++++++++++----------
 drivers/clk/bcm/clk-kona.c       |  212 +++++++++++++++++++++++++++++++--
 drivers/clk/bcm/clk-kona.h       |  160 ++++++++++++++++++++-----
 4 files changed, 611 insertions(+), 233 deletions(-)

-- 
1.7.9.5

