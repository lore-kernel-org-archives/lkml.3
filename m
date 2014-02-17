Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaBQNOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:14:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:22975 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbaBQNOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:14:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,860,1384329600"; 
   d="scan'208";a="482904385"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 00/11] mei fixes and cleanups
Date: Mon, 17 Feb 2014 15:12:41 +0200
Message-Id: <1392642772-8829-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexander Usyskin (4):
  mei: hbm: revamp client connect and disconnection status
  mei: fix potential read outside of array bounds
  mei: use helper function to find me client by id
  mei: make return values consistent across the driver

Tomas Winkler (7):
  mei: add mei_hbuf_acquire wrapper
  mei: revamp writing slot counting
  mei: Remove all bus devices from the mei_dev list when stopping the
    MEI
  mei: wd and amthif use mei_cl_ api for dis/connection
  mei: don't of list_for_each_entry_safe when not deleting
  mei: wd: simplify wd_send command
  mei: wd: fix stop completion failure

 drivers/misc/mei/amthif.c    |  63 +++++-------
 drivers/misc/mei/bus.c       |  20 +++-
 drivers/misc/mei/client.c    | 222 +++++++++++++++++++++++--------------------
 drivers/misc/mei/client.h    |   4 +-
 drivers/misc/mei/hbm.c       | 209 ++++++++++++++++++++--------------------
 drivers/misc/mei/hw-me.c     |  12 ++-
 drivers/misc/mei/hw-txe.c    |  38 ++++----
 drivers/misc/mei/hw-txe.h    |   1 +
 drivers/misc/mei/hw.h        |  16 ++--
 drivers/misc/mei/init.c      |   2 +
 drivers/misc/mei/interrupt.c | 113 ++++++++++------------
 drivers/misc/mei/main.c      |   4 +-
 drivers/misc/mei/mei_dev.h   |   9 +-
 drivers/misc/mei/nfc.c       |  14 +--
 drivers/misc/mei/wd.c        | 135 ++++++++++++++------------
 15 files changed, 441 insertions(+), 421 deletions(-)

-- 
1.8.5.3

