Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaKCDEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 22:04:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:30742 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaKCDEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:04:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="410147557"
From: Kweh Hock Leong <hock.leong.kweh@intel.com>
To: Matt Fleming <matt.fleming@intel.com>, Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: [PATCH v2 0/3] Enable user helper interface for efi capsule update
Date: Mon,  3 Nov 2014 11:07:07 +0800
Message-Id: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

Hi Guys,

This patchset is created on top of "efi: Capsule update support" patch:
http://permalink.gmane.org/gmane.linux.kernel.efi/4837

It leverages the request_firmware_nowait() to expose the user helper interface for user to upload the capsule binary and calling the
efi_capsule_update() API to pass the binary to EFI firmware.

Besides build in kernel, the design also cater for build as kernel driver module. This patchset introduce a new API (request_firmware_abort()) at firmware_class so that the driver module could be unloaded by calling the API to properly stop user helper interface and release the device.

Thanks.

---
changelog v2:
[PATCH 1/3]
* use fw_lookup_buf() instead of __fw_lookup_buf() function call
* move the fw_lookup_buf() function out of the CONFIG_PM_SLEEP block

[PATCH 2/3]
* no change

[PATCH 3/3]
* no change


Kweh, Hock Leong (3):
  firmware loader: Introduce new API - request_firmware_abort()
  firmware loader: fix hung task warning dump
  efi: Capsule update with user helper interface

 drivers/base/firmware_class.c                  |   56 ++++--
 drivers/firmware/efi/Kconfig                   |   13 ++
 drivers/firmware/efi/Makefile                  |    1 +
 drivers/firmware/efi/efi-capsule-user-helper.c |  246 ++++++++++++++++++++++++
 include/linux/firmware.h                       |    4 +
 5 files changed, 306 insertions(+), 14 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-capsule-user-helper.c

-- 
1.7.9.5

