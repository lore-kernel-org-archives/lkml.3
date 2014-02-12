Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaBLTmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:42:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:34523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbaBLTmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:42:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,834,1384329600"; 
   d="scan'208";a="480457381"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/4] mei: fix txe write issue
Date: Wed, 12 Feb 2014 21:41:50 +0200
Message-Id: <1392234114-4926-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes issue on the TXE hardware
when parallel clients would override each others
writes to host.

In order to avoid conflicts please apply after
mei: set client's read_cb to NULL when flow control fails
https://lkml.org/lkml/2014/2/12/389


Tomas Winkler (4):
  mei: rename MEI_FOP_IOCTL to MEI_FOP_CONNECT
  mei: get rid of ext_msg
  mei: add mei_hbuf_acquire wrapper
  mei: revamp writing slot counting

 drivers/misc/mei/amthif.c    |  28 ++++------
 drivers/misc/mei/client.c    |  77 +++++++++++++++-----------
 drivers/misc/mei/client.h    |   4 +-
 drivers/misc/mei/hbm.c       |  66 +++++++++++++++-------
 drivers/misc/mei/hbm.h       |   1 +
 drivers/misc/mei/hw-me.c     |   7 +--
 drivers/misc/mei/hw-txe.c    |  38 ++++++-------
 drivers/misc/mei/hw-txe.h    |   1 +
 drivers/misc/mei/init.c      |   1 -
 drivers/misc/mei/interrupt.c | 127 ++++++++++++++++++++++++-------------------
 drivers/misc/mei/mei_dev.h   |  26 ++++-----
 drivers/misc/mei/wd.c        |  14 ++---
 12 files changed, 220 insertions(+), 170 deletions(-)

-- 
1.8.5.3

