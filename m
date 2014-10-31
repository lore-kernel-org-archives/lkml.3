Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbaJaGI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:08:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:17515 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759551AbaJaGI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:08:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="408929969"
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lee Jones <lee.jones@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/3] Support PMIC operation region for CrystalCove and XPower
Date: Fri, 31 Oct 2014 14:08:22 +0800
Message-Id: <1414735705-18366-1-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Intel Baytrail-T and Baytrail-T-CR platforms, there are two customized
ACPI operation regions defined for the Power Management Integrated Circuit
device, one is for power resource handling and one is for thermal: sensor
temperature reporting, trip point setting, etc. There are different PMIC
chips used on those platforms and though each has the same two operation
regions and functionality, their implementation is different so every PMIC
will need a driver. But since their functionality is similar, some common
code is abstracted into the intel_soc_pmic_opregion.c.

The last version is posted here:
https://lkml.org/lkml/2014/9/8/801

Changes since then:
1 Move to drivers/acpi as discussed on the above thread;
2 Added support for XPower AXP288 PMIC operation region support;
3 Since operation region handler can not be removed(at the moment at least),
  use bool for the two operation region driver configs instead of tristate;
  Another reason to do this is that, with Mika's MFD ACPI support patch, all
  those MFD cell devices created will have the same modalias as their parent's
  so it doesn't make much sense to compile these drivers into modules.

Patch 1 applies on top of Rafael's pm-next branch, and then patch 2 and
patch 3 needs merge of Lee's mfd/ib-mfd-iio-3.19 branch where the PMIC
driver XPower AXP288 and iio driver axp288_adc is located.

Aaron Lu (3):
  ACPI / pmic_opregion: support PMIC operation region for CrystalCove
  ACPI / pmic_opregion: support PMIC operation region for XPower AXP288
  ACPI / pmic_opregion: AXP288: support virtual GPIO in ACPI table

