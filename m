Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaKQPam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:30:42 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57044 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaKQPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:30:41 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/3] mfd: cros_ec: Add user-space dev inferface support
Date: Mon, 17 Nov 2014 16:30:10 +0100
Message-Id: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The mainline ChromeOS Embedded Controller (EC) driver is still missing some
features that are present in the downstream ChromiumOS tree. These are:

  - User-space device interface
  - Low Pin Count (LPC) interface
  - Access to vboot context stored on a block device
  - Access to vboot context stored on EC's nvram
  - Power Delivery Device
  - Support for multiple EC in a system

This series adds support for the first of these missing features: the cros
ec dev driver that provides the interface used by user-space to access the
EC. The support patches were taken from the downstream ChromiumOS 3.14
kernel tree with fixes and cleanups squashed to have a minimal patch-set.

The series is composed of the following patches:

Bill Richardson (3):
  mfd: cros_ec: Add Chrome OS EC userspace device interface
  mfd: cros_ec: Create sysfs attributes for the ChromeOS EC.
  mfd: cros_ec: Expose Chrome OS Lightbar to users

 drivers/mfd/Kconfig             |  12 ++
 drivers/mfd/Makefile            |   2 +
 drivers/mfd/cros_ec.c           |   4 +
 drivers/mfd/cros_ec_dev.c       | 363 ++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/cros_ec_dev.h       |  29 ++++
 drivers/mfd/cros_ec_lightbar.c  | 347 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/cros_ec_sysfs.c     | 271 ++++++++++++++++++++++++++++++
 include/linux/mfd/cros_ec.h     |  12 +-
 include/linux/mfd/cros_ec_dev.h |  47 ++++++
 9 files changed, 1086 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mfd/cros_ec_dev.c
 create mode 100644 drivers/mfd/cros_ec_dev.h
 create mode 100644 drivers/mfd/cros_ec_lightbar.c
 create mode 100644 drivers/mfd/cros_ec_sysfs.c
 create mode 100644 include/linux/mfd/cros_ec_dev.h

Patch #1 adds the cros_ec_dev driver that provides the dev interface to
user-space. Patch #2 adds sysfs entries that can be used to get information
and to control the EC and Patch #3 adds sysfs entries to control Chromebook
Pixel's four-element LED lightbar.

The patches were tested on a Exynos5420 Peach Pit Chromebook by using the
sysfs entries and the ectool.

Best regards,
Javier
