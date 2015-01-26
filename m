Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbbAZLN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:13:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:4594 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbbAZLNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:13:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,468,1418112000"; 
   d="scan'208";a="642582575"
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@ml01.01.org, Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Berg Johannes <johannes.berg@intel.com>,
        Clement Perrochaud <clement.perrochaud@nxp.com>,
        Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH v2 0/2] Add ACPI support for NXP PN544
Date: Mon, 26 Jan 2015 13:13:35 +0200
Message-Id: <1422270817-10950-1-git-send-email-robert.dolca@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces ACPI support for PN544.

gpio_set_value was replaced with gpio_set_value_cansleep in order
to allow GPIO access that may sleep. This is particularelly useful
when GPIO is accessed using busses like I2C, SPI, USB

Changes since v1:
	- Added cover letter
	- Removed debug define and Kconfig include
	- Minor fixes to patch subjects

Links to v1:
	- http://lkml.iu.edu/hypermail/linux/kernel/1501.1/00943.html
	- http://lkml.iu.edu/hypermail/linux/kernel/1501.1/00944.html

Robert Dolca (2):
  NFC: PN544: GPIO access that may sleep
  NFC: Add ACPI support for NXP PN544

 drivers/nfc/pn544/i2c.c | 137 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 124 insertions(+), 13 deletions(-)

-- 
1.9.1

