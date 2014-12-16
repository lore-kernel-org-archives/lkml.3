Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaLPP5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:57:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:28514 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbaLPP5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:57:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="499594762"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, lee.jones@linaro.org
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v2 0/4] DLN2 fixes related to suspend/resume
Date: Tue, 16 Dec 2014 17:57:11 +0200
Message-Id: <1418745435-2851-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 2nd patch set addresses Johan review comments:

 * Fix an issue introduced by v1 where we can get a use after free in
   the error path of probe

 * Add start/stop RX URBs helpers

 * move the suspend/resume routines above the module device table

 * used GFP_NOIO in resume

Octavian Purdila (4):
  gpio: dln2: fix issue when an IRQ is unmasked then enabled
  gpio: dln2: use bus_sync_unlock instead of scheduling work
  mfd: dln2: add start/stop RX URBs helpers
  mfd: dln2: add suspend/resume functionality

 drivers/gpio/gpio-dln2.c | 141 +++++++++++++++++++----------------------------
 drivers/mfd/dln2.c       |  71 ++++++++++++++++++++----
 2 files changed, 117 insertions(+), 95 deletions(-)

-- 
1.9.1

