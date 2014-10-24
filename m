Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaJXGPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:15:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:41382 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbaJXGPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:15:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,778,1406617200"; 
   d="scan'208";a="619636694"
From: Kweh Hock Leong <hock.leong.kweh@intel.com>
To: Matt Fleming <matt.fleming@intel.com>, Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: [PATCH v1 0/3] Enable user helper interface for efi capsule update
Date: Fri, 24 Oct 2014 14:18:19 +0800
Message-Id: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

Hi Guys,

This patchset is created on top of "efi: Capsule update support" patch:
http://permalink.gmane.org/gmane.linux.kernel.efi/4837

It leverages the request_firmware_nowait() to expose the user helper
interface for user to upload the capsule binary and calling the
efi_capsule_update() API to pass the binary to EFI firmware.

Besides build in kernel, the design also cater for build as kernel driver
module. This patchset introduce a new API (request_firmware_abort()) at
firmware_class so that the driver module could be unloaded by calling
the API to properly stop user helper interface and release the device.

Thanks.


Kweh, Hock Leong (3):
  firmware loader: Introduce new API - request_firmware_abort()
  firmware loader: fix hung task warning dump
  efi: Capsule update with user helper interface

 drivers/base/firmware_class.c                  |   34 +++-
 drivers/firmware/efi/Kconfig                   |   13 ++
 drivers/firmware/efi/Makefile                  |    1 +
 drivers/firmware/efi/efi-capsule-user-helper.c |  246 ++++++++++++++++++++++++
 include/linux/firmware.h                       |    4 +
 5 files changed, 296 insertions(+), 2 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-capsule-user-helper.c

-- 
1.7.9.5

