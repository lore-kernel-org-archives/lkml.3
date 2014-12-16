Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaLPQRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:17:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:2905 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaLPQRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:17:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,587,1413270000"; 
   d="scan'208";a="624666031"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, lee.jones@linaro.org, rjw@rjwysocki.net
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, heikki.krogerus@intel.com,
        mika.westerberg@linux.intel.com, linux-acpi@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH 0/4] dln2: add support for ACPI 
Date: Tue, 16 Dec 2014 18:12:29 +0200
Message-Id: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets adds support for ACPI enumeration for devices
connected to the DLN2 bridge via a custom ACPI table.

The first two patches fix a couple of issues with the ACPI load/unload
table APIs.

The 3rd patch adds ACPI support to the MFD driver and the last patch
configures pull-up/pull-down on GPIO pins based on the APCI
configuration.

Octavian Purdila (4):
  ACPICA: take ACPI_MTX_INTERPRETER in acpi_unload_table_id
  ACPICA: don't release ACPI_MTX_TABLES in
    acpi_tb_install_standard_table
  mfd: dln2: add support for ACPI
  gpio: dln2: add support for ACPI pin configuration

 Documentation/acpi/dln2-acpi.txt |  62 ++++++++++++++++++
 drivers/acpi/acpica/tbinstal.c   |   1 -
 drivers/acpi/acpica/tbxface.c    |   7 ++
 drivers/gpio/gpio-dln2.c         |  76 ++++++++++++++++++++++
 drivers/mfd/dln2.c               | 134 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 279 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/acpi/dln2-acpi.txt

-- 
1.9.1

