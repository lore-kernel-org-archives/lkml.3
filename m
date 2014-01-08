Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaAHSU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:20:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:58372 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaAHSU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:20:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,625,1384329600"; 
   d="scan'208";a="463655402"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 0/4] mei: reset fix
Date: Wed,  8 Jan 2014 20:19:20 +0200
Message-Id: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series should address possible hiccup in
mei reset flow presenting itself as never ending   
repetition of error line.

unexpected reset: dev_state = RESETTING  

The patches make sure that stall watchdog doesn't jump in 
prior to its time; second the reset flow won't recuse,
and at last  it will allow no more than 3 consecutive resets
for misbehaving hardware.


Tomas Winkler (4):
  mei: do not run reset flow from the interrupt thread
  mei: use hbm idle state to prevent spurious resets
  mei: revamp mei reset state machine
  mei: limit the number of consecutive resets

 drivers/misc/mei/client.c    |   1 +
 drivers/misc/mei/hbm.c       | 221 ++++++++++++++++++++++------------
 drivers/misc/mei/hbm.h       |   7 +-
 drivers/misc/mei/hw-me.c     |  40 +++----
 drivers/misc/mei/init.c      | 280 +++++++++++++++++++++++++++----------------
 drivers/misc/mei/interrupt.c |  45 ++++---
 drivers/misc/mei/mei_dev.h   |  11 +-
 drivers/misc/mei/pci-me.c    |  10 +-
 8 files changed, 386 insertions(+), 229 deletions(-)

-- 
1.8.4.2

