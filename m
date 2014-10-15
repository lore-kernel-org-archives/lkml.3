Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJOUDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:03:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:40678 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaJOUDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:03:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="400857882"
From: Octavian Purdila <octavian.purdila@intel.com>
To: wsa@the-dreams.de
Cc: linux@roeck-us.net, johan@kernel.org, linux-i2c@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATH v3 0/4] i2c: show and change bus frequency via sysfs
Date: Wed, 15 Oct 2014 23:03:27 +0300
Message-Id: <1413403411-8895-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support to show and change the bus frequency
via sysfs, by exposing files to show the minimum, maximum and current
frequency as well as allowing the frequency to be changed. This allows
the user to view or change the bus frequency on a per bus level.

Changes since v3:

 * use DEVICE_ATTR_RO and make i2c_adapter_visible_attr static
 
 * implement sysfs bus frequency support for the diolan u2c bus

Octavian Purdila (4):
  i2c: document the existing i2c sysfs ABI
  i2c: document struct i2c_adapter
  i2c: show and change bus frequency via sysfs
  i2c: i2c-diolan-u2c: sysfs bus frequency support

 Documentation/ABI/testing/sysfs-bus-i2c | 75 +++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-diolan-u2c.c     | 49 ++++++++++++------
 drivers/i2c/i2c-core.c                  | 90 +++++++++++++++++++++++++++++++++
 include/linux/i2c.h                     | 32 ++++++++++--
 4 files changed, 228 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c

-- 
1.9.1

