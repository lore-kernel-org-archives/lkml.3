Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaJTPdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:33:13 -0400
Received: from sauhun.de ([89.238.76.85]:56117 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaJTPdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:33:11 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 0/4] platform: fix accidently erasing .owner
Date: Mon, 20 Oct 2014 17:33:40 +0200
Message-Id: <1413819224-12677-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since platform_register_driver() was converted to set the .owner of a driver,
there was a codepath on which the owner would have been erased. This series
fixes that and adds a warning to prevent such cases go unnoticed in the future.
For consistency, a semantic patch is also added which reports when .owner gets
unnecissarily set. More details in the patch descriptions. Thanks go to Russell
King for pointing out this problem and to Julia Lawall for help with the
semantic patch.

All these patches have been tested on a custom board.

Please apply. The cleanup series for removing .owner in the kernel tree will
come tomorrow as a seperate pull request.

Wolfram Sang (4):
  core: platform: add warning if driver has no owner
  core: platform: let platform_driver_probe initialize module owner
  core: platform: let platform_create_bundle initialize module owner
  coccinelle: api: add spatch to prevent unnecessary .owner

 drivers/base/driver.c                              |   3 +
 drivers/base/platform.c                            |  22 +++--
 include/linux/platform_device.h                    |  12 ++-
 scripts/coccinelle/api/platform_no_drv_owner.cocci | 106 +++++++++++++++++++++
 4 files changed, 129 insertions(+), 14 deletions(-)
 create mode 100644 scripts/coccinelle/api/platform_no_drv_owner.cocci

-- 
2.0.0

