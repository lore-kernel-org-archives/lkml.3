Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaEEUDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:03:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48252 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaEEUDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:03:44 -0400
Date: Mon, 5 May 2014 15:03:22 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [GIT PULL #1/2] bus: omap_l3_noc: driver fixes and DRA7/AM437x
 support
Message-ID: <20140505200322.GA9863@kahuna>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1398698101-25513-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398698101-25513-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

   Please pull the following driver fixes based on V3 of l3noc fixes and
   support for DRA7 and AM437x for upcoming 3.16 window.
   http://marc.info/?l=linux-omap&m=139869922030493&w=2

   This is part 1 of the pull request containing purely the driver
   updates.

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  https://github.com/nmenon/linux-2.6-playground.git pull/l3noc/driver-fixes

for you to fetch changes up to 27b7d5f3cc49f2e5cd6c005d73696058b7140c5c:

  bus: omap_l3_noc: Add AM4372 interconnect error data (2014-05-05 14:34:37 -0500)

----------------------------------------------------------------
Afzal Mohammed (2):
      bus: omap_l3_noc: ignore masked out unclearable targets
      bus: omap_l3_noc: Add AM4372 interconnect error data

Nishanth Menon (14):
      bus: omap_l3_noc: Fix copyright information
      bus: omap_l3_noc: remove iclk from omap_l3 struct
      bus: omap_l3_noc: populate l3->dev and use it
      bus: omap_l3_noc: switch over to relaxed variants of readl/writel
      bus: omap_l3_noc: un-obfuscate l3_targ address computation
      bus: omap_l3_noc: move L3 master data structure out
      bus: omap_l3_noc: convert target information into a structure
      bus: omap_l3_noc: convert flagmux information into a structure
      bus: omap_l3_noc: fix masterid detection
      bus: omap_l3_noc: make error reporting and handling common
      bus: omap_l3_noc: improve readability by using helper for slave event parsing
      bus: omap_l3_noc: add information about the type of operation
      bus: omap_l3_noc: Add information about the context of operation
      bus: omap_l3_noc: introduce concept of submodule

Peter Ujfalusi (5):
      drivers: bus: omap_l3: Convert to use devm_kzalloc
      drivers: bus: omap_l3: Convert to use devm_ioremap_resource()
      drivers: bus: omap_l3: Convert to use devm_request_irq()
      drivers: bus: omap_l3: Remove the platform driver's remove function
      drivers: bus: omap_l3: Change pr_crit() to dev_err() when IRQ request fails

Rajendra Nayak (2):
      bus: omap_l3_noc: Add support for discountinous flag mux input numbers
      bus: omap_l3_noc: Add DRA7 interconnect error data

Sricharan R (2):
      bus: omap_l3_noc: rename functions and data to omap_l3
      bus: omap_l3_noc: use of_match_data to pick up SoC information

 .../devicetree/bindings/arm/omap/l3-noc.txt        |    2 +
 drivers/bus/omap_l3_noc.c                          |  406 ++++++++-------
 drivers/bus/omap_l3_noc.h                          |  545 +++++++++++++++-----
 3 files changed, 653 insertions(+), 300 deletions(-)
-- 
Regards,
Nishanth Menon
