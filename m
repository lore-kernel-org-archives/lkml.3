Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3I0Q5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:57:06 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:33362 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab3I0Q5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:57:01 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v6 0/2] mmc: sdhci-msm: Add support for MSM chipsets
Date: Fri, 27 Sep 2013 19:57:19 +0300
Message-Id: <1380301041-26405-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support of the Secure Digital Host Controller
Interface compliant controller found in Qualcomm MSM chipsets.
It has been tested on a APQ8074 Dragonboard.

Changes from v5:
- Driver is split into multiple patches
- Do not initialize variables that are assigned later in code
- Remove some useless comments
- Use shorter variable names
- Change pr_err() to dev_err()
- Optimized sdhci_msm_setup_vreg()
- Some code alignment fixes
- Improved DT values sanity check
- Added dev_dbg print for sdhci controller version in probe()
- Added usleep_range() after SW reset - it can take some time
- Added SDHCI_QUIRK_SINGLE_POWER_WRITE - power handled by PMIC
- Renamed DT property vdd-io to vddio

Changes from v4:
- Simplified sdhci_msm_vreg_disable() and sdhci_msm_set_vdd_io_vol()
- Use devm_ioremap_resource() instead of devm_ioremap()
- Converted IS_ERR_OR_NULL to IS_ERR
- Disable regulators in sdhci_msm_remove()
- Check for DT node at the beginning in sdhci_msm_probe()
- Removed more redundant code
- Changes in some error messages
- Minor fixes

Changes from v3:
- Allocate memory for all required structs at once
- Added termination entry in sdhci_msm_dt_match[]
- Fixed a missing sdhci_pltfm_free() in probe()
- Removed redundant of_match_ptr
- Removed the unneeded function sdhci_msm_vreg_reset()

Changes from v2:
- Added DT bindings for clocks
- Moved voltage regulators data to platform data
- Removed unneeded includes
- Removed obsolete and wrapper functions
- Removed error checking where unnecessary
- Removed redundant _clk suffix from clock names
- Just return instead of goto where possible
- Minor fixes

Changes from v1:
- GPIO references are replaced by pinctrl
- DT parsing is done mostly by mmc_of_parse()
- Use of_match_device() for DT matching
- A few minor changes

Georgi Djakov (2):
  mmc: sdhci-msm: Initial SDHCI MSM driver documentation
  mmc: sdhci-msm: Initial support for MSM chipsets

 .../devicetree/bindings/mmc/sdhci-msm.txt          |   70 +++
 drivers/mmc/host/Kconfig                           |   13 +
 drivers/mmc/host/Makefile                          |    1 +
 drivers/mmc/host/sdhci-msm.c                       |  644 ++++++++++++++++++++
 4 files changed, 728 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt
 create mode 100644 drivers/mmc/host/sdhci-msm.c

-- 
1.7.9.5

