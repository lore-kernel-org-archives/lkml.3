Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3DVCNi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:13:38 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:41712 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3DVCNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:13:36 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Raisch <raisch@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Hoang-Nam Nguyen <hnguyen@de.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-rdma@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH 0/5] of_platform_driver and OF_DEVICE removal
Date: Sun, 21 Apr 2013 21:13:13 -0500
Message-Id: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series is a relatively straight-forward removal of the last remaining
user of of_platform_driver (ibmebus) and removal of CONFIG_OF_DEVICE which
is always enabled when CONFIG_OF is enabled.

Compile tested on powerpc and sparc.

Rob

Rob Herring (5):
  ibmebus: convert of_platform_driver to platform_driver
  driver core: move to_platform_driver to platform_device.h
  of: remove of_platform_driver
  usb: chipidea: depend on CONFIG_OF instead of CONFIG_OF_DEVICE
  of: remove CONFIG_OF_DEVICE

 arch/powerpc/include/asm/ibmebus.h        |    4 ++--
 arch/powerpc/kernel/ibmebus.c             |   22 ++++++++++-----------
 drivers/base/platform.c                   |    3 ---
 drivers/infiniband/hw/ehca/ehca_main.c    |    5 ++---
 drivers/net/ethernet/ibm/ehea/ehea_main.c |    8 +++-----
 drivers/of/Kconfig                        |    3 ---
 drivers/of/Makefile                       |    3 +--
 drivers/usb/chipidea/Makefile             |    2 +-
 include/linux/of_device.h                 |    6 +++---
 include/linux/of_platform.h               |   30 +----------------------------
 include/linux/platform_device.h           |    3 +++
 11 files changed, 26 insertions(+), 63 deletions(-)

-- 
1.7.10.4

