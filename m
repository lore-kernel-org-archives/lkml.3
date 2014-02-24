Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaBXK1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:27:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbaBXKZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:25:45 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kys@microsoft.com, abgupta@microsoft.com, haiyangz@microsoft.com,
        jasowang@redhat.com, tomi.valkeinen@ti.com,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v2 0/5] hyperv-fb: add support for generation 2 virtual machines.
Date: Mon, 24 Feb 2014 11:25:11 +0100
Message-Id: <1393237516-28545-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

This patch series adds support for uefi-based gen2 virtual machines to
the hyperv-fb driver.

Patch #1 is included just for completeness.  Greg picked it up
already and it is in -next, but it isn't in master yet.

Patch #2 is a bugfix for the first patch.

Patch #3 changes vmbus to properly hook the hyperv mmio area into
the linux resource management.

Patch #4 actually implements gen2 vm support for hyperv-fb, building
on the hyperv mmio support added by the other patches.

Patch #5 unregisters efifb early to make sure the framebuffer isn't used
any more while hyperv-fb initialization is in progress.  This patch is
new in v2 and it fixes the hang listed as "known issue" in v1 of this
patch series.

please apply,
  Gerd

Gerd Hoffmann (4):
  vmbus: add missing breaks
  vmbus: use resource for hyperv mmio region
  hyperv-fb: add support for generation 2 virtual machines.
  hyperv-fb: kick off efifb early

K. Y. Srinivasan (1):
  Drivers: hv: vmbus: Extract the mmio information from DSDT

 drivers/hv/vmbus_drv.c    | 51 ++++++++++++++++++++-------
 drivers/video/hyperv_fb.c | 87 +++++++++++++++++++++++++++++++++--------------
 include/linux/hyperv.h    |  2 ++
 3 files changed, 101 insertions(+), 39 deletions(-)

-- 
1.8.3.1

