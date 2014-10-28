Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaJ1Qkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:40:47 -0400
Received: from sauhun.de ([89.238.76.85]:46884 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbaJ1Qkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:40:32 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH RESEND 0/4] platform: fix accidently erasing .owner
Date: Tue, 28 Oct 2014 17:40:39 +0100
Message-Id: <1414514443-28943-1-git-send-email-wsa@the-dreams.de>
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

This resend was rebased to rc2. It produced identical patches. IMO this should
go into v3.18 since it is a bugfix.

Please apply. The cleanup series for removing .owner in the kernel tree will
be resend later, too, as a seperate pull request.

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

