Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3JUTPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:15:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:39506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab3JUTPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:15:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414681883"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/8] mei security fixes and cleanups
Date: Mon, 21 Oct 2013 22:05:35 +0300
Message-Id: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add fixes for possible security holes
mostly pointed out by static analysis tools and probably
not all of them are real with exception the nfc memory leak.

Alexander Usyskin (2):
  mei: replace stray pr_debug with dev_dbg
  mei: print correct device state during unexpected reset

Tomas Winkler (6):
  mei: debugfs: validate dev is not null
  mei: hbm: validate client index is not exceeding allocated array size
  mei: nfc: fix memory leak in error path
  mei: wd: host_init propagate error codes from called functions
  mei: bus: propagate error code returned by mei_me_cl_by_id
  mei: mei_cl_link remove duplicated check for open_handle_count

 drivers/misc/mei/bus.c     |  2 +-
 drivers/misc/mei/client.c  |  6 ------
 drivers/misc/mei/debugfs.c | 12 ++++++++++--
 drivers/misc/mei/hbm.c     |  6 ++++--
 drivers/misc/mei/init.c    |  8 ++++----
 drivers/misc/mei/nfc.c     | 10 ++++++----
 drivers/misc/mei/pci-me.c  |  2 +-
 drivers/misc/mei/wd.c      | 12 ++++++------
 8 files changed, 32 insertions(+), 26 deletions(-)

-- 
1.8.3.1

