Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaDVGcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:32:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:30776 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbaDVGcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:32:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,901,1389772800"; 
   d="scan'208";a="497160821"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, tianyu.lan@intel.com
Subject: [Resend Patch 0/9] I2C ACPI operation region handler support 
Date: Tue, 22 Apr 2014 14:24:06 +0800
Message-Id: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operation
region. It allows ACPI aml code able to access such kind of devices to
implement some ACPI standard method.

On the Asus T100TA, Bios use GenericSerialBus operation region to access
i2c device to get battery info. So battery function depends on the I2C
operation region support. Here is the bug link.
https://bugzilla.kernel.org/show_bug.cgi?id=69011

This patchset is to add I2C ACPI operation region handler support.

[Resend Patch 1/9] ACPICA: Executer: Fix buffer allocation issue for
[Resend Patch 2/9] ACPICA: Export acpi_buffer_to_resource symbol
[Resend Patch 3/9] ACPI: Add acpi_bus_attach_private_data() to
[Resend Patch 4/9] ACPI/Thermal: Use acpi_bus_attach_private_data()
[Resend Patch 5/9] I2C: Add smbus quick read/write helper function
[Resend Patch 6/9] I2C: Add smbus word/block process call helper
[Resend Patch 7/9] I2C/ACPI: Add i2c ACPI operation region support
[Resend Patch 8/9] I2C/ACPI: Move ACPI related code to i2c-acpi.c
[Resend Patch 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config

 drivers/acpi/acpica/exfield.c  | 104 +++++++++++++++++++++++++++++++++++++++++++++----
 drivers/acpi/acpica/rscreate.c |   1 +
 drivers/acpi/bus.c             |  18 ++++++++-
 drivers/acpi/thermal.c         |   9 ++---
 drivers/i2c/Kconfig            |  17 +++++++-
 drivers/i2c/Makefile           |   5 ++-
 drivers/i2c/i2c-acpi.c         | 371 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/i2c/i2c-core.c         | 183 +++++++++++++++++++++++++++++++++++++++++--------------------------------------------
 include/acpi/acpi_bus.h        |   1 +
 include/linux/acpi.h           |  11 ++++++
 include/linux/i2c.h            |  19 +++++++++
 11 files changed, 628 insertions(+), 111 deletions(-)
