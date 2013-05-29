Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966814Ab3E2PIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:08:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38068 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966095Ab3E2PIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:08:00 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 0/7] thermal: ti-soc-thermal: fixes and DRA752 support
Date: Wed, 29 May 2013 11:07:39 -0400
Message-ID: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rui,

Here is a patch set for your consideration on ti-soc-thermal driver.

This patch set is mix of:

(a) patches that were added to the staging tree post 3.10-rc1 but
were not included after the move from staging to thermal. This is
because your thermal tree is based of 3.10-rc1 and not staging/next
or linux-next/master. Thus the first two patches make sure the driver
under drivers/thermal/ti-soc-thermal has also the needed fixes.

(b) patches containing fixes found during the addition of DRA752
chip support.

(c) patches adding the support to DRA752 chips.

Please consider these too for 3.11.

For those people interested in testing this patch set, it is based
on thermal/next and can also be found here:
https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/ti-soc-thermal/fixes+dra752

All best,

Eduardo Valentin (7):
  thermal: ti-soc-thermal: update DT reference for OMAP5430
  thermal: ti-soc-thermal: remove external heat while extrapolating
    hotspot
  thermal: ti-soc-thermal: freeze FSM while computing trend
  thermal: ti-soc-thermal: remove usage of IS_ERR_OR_NULL
  thermal: ti-soc-thermal: add thermal data for DRA752 chips
  thermal: ti-soc-thermal: add dra752 chip to device table
  thermal: ti-soc-thermal: add DT example for DRA752 chip

 .../devicetree/bindings/thermal/ti_soc_thermal.txt |  13 +
 drivers/staging/ti-soc-thermal/dra752-bandgap.h    | 280 ++++++++++++
 .../staging/ti-soc-thermal/dra752-thermal-data.c   | 476 +++++++++++++++++++++
 drivers/thermal/ti-soc-thermal/Kconfig             |  12 +
 drivers/thermal/ti-soc-thermal/Makefile            |   1 +
 drivers/thermal/ti-soc-thermal/ti-bandgap.c        |  29 +-
 drivers/thermal/ti-soc-thermal/ti-bandgap.h        |   5 +
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  43 +-
 drivers/thermal/ti-soc-thermal/ti-thermal.h        |   6 +
 9 files changed, 842 insertions(+), 23 deletions(-)
 create mode 100644 drivers/staging/ti-soc-thermal/dra752-bandgap.h
 create mode 100644 drivers/staging/ti-soc-thermal/dra752-thermal-data.c

-- 
1.8.2.1.342.gfa7285d

