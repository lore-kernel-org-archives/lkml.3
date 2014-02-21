Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaBUI5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:57:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaBUI5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:57:07 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kys@microsoft.com, haiyangz@microsoft.com, jasowang@redhat.com,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 0/4] hyperv-fb: add support for generation 2 virtual machines
Date: Fri, 21 Feb 2014 09:56:40 +0100
Message-Id: <1392973004-28215-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

This patch series adds support for uefi-based gen2 virtual machines to
the hyperv-fb driver.

First patch is included just for completeness.  Greg picked it up
already and it is in -next, but it isn't in master yet.

Second patch is a bugfix for the first patch.

Third patch changes vmbus to properly hook the hyperv mmio area into
the linux resource management.

Final patch actually implements gen2 vm support for hyperv-fb, building
on the hyperv mmio support added by the other patches.

Known issue: There is a long delay when loading the hyperv-fb driver on
gen2 virtual machines which isn't present on gen1 virtual machines.

Gerd Hoffmann (3):
  vmbus: add missing breaks
  vmbus: use resource for hyperv mmio region
  hyperv-fb: add support for generation 2 virtual machines.

K. Y. Srinivasan (1):
  Drivers: hv: vmbus: Extract the mmio information from DSDT

 drivers/hv/vmbus_drv.c    | 51 +++++++++++++++++++++-------
 drivers/video/hyperv_fb.c | 86 +++++++++++++++++++++++++++++++++--------------
 include/linux/hyperv.h    |  2 ++
 3 files changed, 100 insertions(+), 39 deletions(-)

-- 
1.8.3.1

