Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbaLKNEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:04:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:51427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaLKNE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:04:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,557,1413270000"; 
   d="scan'208";a="636109345"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, lee.jones@linaro.org
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH 0/3] DLN2 fixes related to suspend/resume
Date: Thu, 11 Dec 2014 15:02:28 +0200
Message-Id: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch in the series fixes a GPIO IRQ issues found during
suspend/resume testing, the next simplifies a bit the IRQ code and the
last adds support for suspend/resume to DLN2 to avoid a crash during
suspend caused by the fact that we cant unplug a GPIO controller while
it is in use.

As suggested by Johan, I have tested the suspend/resume on barebone
hardware, in addition to KVM USB pass-through and reset_resume routine
is not neccessary on barebone hardware. 

It looks like with KVM USB pass-through the emulated port is reseted
during suspend/resume regardless of the state of the physical port.

Octavian Purdila (3):
  gpio: dln2: fix issue when an IRQ is unmasked then enabled
  gpio: dln2: use bus_sync_unlock instead of scheduling work
  mfd: dln2: add suspend/resume functionality

 drivers/gpio/gpio-dln2.c | 141 +++++++++++++++++++----------------------------
 drivers/mfd/dln2.c       |  41 +++++++++++++-
 2 files changed, 94 insertions(+), 88 deletions(-)

-- 
1.9.1

