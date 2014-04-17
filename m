Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaDQUxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:53:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40730 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaDQUua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:30 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 00/19] bus: omap_l3_noc: driver cleanups and support for DRA7/AM4372 
Date: Thu, 17 Apr 2014 15:49:16 -0500
Message-ID: <1397767775-10965-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397492726-17203-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following V2 of the series is based on v3.15-rc1 + peter's patch series:
	patch #1: https://patchwork.kernel.org/patch/3923141/
	(drivers: bus: omap_l3: Convert to use devm_kzalloc)

	patch #2: https://patchwork.kernel.org/patch/3923061/
	(drivers: bus: omap_l3: Convert to use devm_ioremap_resource() )

	patch #3: https://patchwork.kernel.org/patch/3923101/
	(drivers: bus: omap_l3: Convert to use devm_request_irq())

	patch #4: https://patchwork.kernel.org/patch/3923081/
	(drivers: bus: omap_l3: Remove the platform driver's remove function)

	patch #5: https://patchwork.kernel.org/patch/3923121/
	(drivers: bus: omap_l3: Change pr_crit() to dev_err() when IRQ request
	fails)

V1 was originally posted here: http://marc.info/?l=linux-omap&m=139749383932575&w=2

V2 introduces the following changes:
	- Additional bug fix detected during additional testing (all tests complete now). patch #12
	- reordering of patches to order logical changes and reduce code churn.
	- interrupt handler split up and additional information now provided in log to aid debug when error occur
	- patches are marked where new (12,14,15,16).
	- DRA7 updated from master document for all DRA7 variants.

This series cleansup omap_l3_noc driver and adds data to support DRA7
and AM437x SoCs.

Patches(including Peter's) is available here:
https://github.com/nmenon/linux-2.6-playground/commits/l3noc/driver-fixes-v2

DTS patches (once this series is integrated and related DRA7 memory map fixes are done):
https://github.com/nmenon/linux-2.6-playground/commits/l3noc/dts-fixes
	(posted here: http://marc.info/?l=linux-omap&m=139750288003978&w=2)
		- no change in dts.

Testing branch: everything integrated:
https://github.com/nmenon/linux-2.6-playground/commits/l3noc/testing-v2

Test logs: (DES enabled to trigger the bug fixed by https://patchwork.kernel.org/patch/3994211/)
	am43xx-epos: http://slexy.org/raw/s2zPoMnkiM
	DRA7xx-EVM: http://slexy.org/raw/s20H3aHsNv
	pandaboard-es: http://slexy.org/raw/s21gREgRKi
	   sdp4430: http://slexy.org/raw/s20hDTF5Y6
	OMAP5432uEVM: http://slexy.org/raw/s21dk0Qshx

Afzal Mohammed (1):
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
  bus: omap_l3_noc: improve readability by using helper for slave event
    parsing
  bus: omap_l3_noc: add information about the type of operation
  bus: omap_l3_noc: Add information about the context of operation
  bus: omap_l3_noc: introduce concept of submodule

Rajendra Nayak (2):
  bus: omap_l3_noc: Add support for discountinous flag mux input
    numbers
  bus: omap_l3_noc: Add DRA7 interconnect error data

Sricharan R (2):
  bus: omap_l3_noc: rename functions and data to omap_l3
  bus: omap_l3_noc: use of_match_data to pick up SoC information

 .../devicetree/bindings/arm/omap/l3-noc.txt        |    2 +
 drivers/bus/omap_l3_noc.c                          |  317 ++++++++----
 drivers/bus/omap_l3_noc.h                          |  529 +++++++++++++++-----
 3 files changed, 621 insertions(+), 227 deletions(-)

-- 
1.7.9.5

