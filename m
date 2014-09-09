Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaIICcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:32:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:9501 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbaIICcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:32:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,490,1406617200"; 
   d="scan'208";a="599999545"
From: Aaron Lu <aaron.lu@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-gpio@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
        linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 0/2] Support CrystalCove PMIC ACPI operation region
Date: Tue,  9 Sep 2014 10:32:46 +0800
Message-Id: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two patches add support for CrystalCove PMIC ACPI operation region.
The PMIC chip has two customized operation regions: one for power rail
manipulation and one for thermal purpose: sensor temperature reading
and trip point value reading/setting.

For an example ASL code on ASUS T100 with CrystalCove PMIC, see here:
https://gist.github.com/aaronlu/f5f65771a6c3251fae5d

Aaron Lu (2):
  gpio / CrystalCove: support virtual GPIO
  PMIC / opregion: support PMIC customized operation region for
    CrystalCove

 drivers/gpio/gpio-crystalcove.c           |  19 +-
 drivers/mfd/Kconfig                       |  11 +
 drivers/mfd/Makefile                      |   1 +
 drivers/mfd/intel_soc_pmic_crc.c          |   3 +
 drivers/mfd/intel_soc_pmic_crc_opregion.c | 229 +++++++++++++++++++
 drivers/mfd/intel_soc_pmic_opregion.c     | 350 ++++++++++++++++++++++++++++++
 drivers/mfd/intel_soc_pmic_opregion.h     |  35 +++
 include/asm-generic/gpio.h                |   2 +-
 8 files changed, 646 insertions(+), 4 deletions(-)
 create mode 100644 drivers/mfd/intel_soc_pmic_crc_opregion.c
 create mode 100644 drivers/mfd/intel_soc_pmic_opregion.c
 create mode 100644 drivers/mfd/intel_soc_pmic_opregion.h

-- 
1.9.3

