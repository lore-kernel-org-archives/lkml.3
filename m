Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab3BFMG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:06:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:39279 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab3BFMGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:06:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,615,1355126400"; 
   d="scan'208";a="287310800"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/6] MEI and ME separation
Date: Wed,  6 Feb 2013 14:06:38 +0200
Message-Id: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are about to introduce new under laying hardware
that supports MEI interface. For that purpose we
split the driver into interface hand hardware specific layers

Tomas Winkler (6):
  mei: sperate interface and pci code into two files
  mei: initial extract of ME hw specifics from mei_device
  mei: separate compilation of the ME hardware specifics
  mei: move interrupt handlers to be me hw specific
  mei: rename to mei_host_buffer_is_empty to hbuf_is_ready
  mei: move clients cleanup code from init.c to client.c

 drivers/misc/mei/Kconfig     |   17 ++-
 drivers/misc/mei/Makefile    |    5 +-
 drivers/misc/mei/amthif.c    |   12 +-
 drivers/misc/mei/client.c    |   64 ++++++-
 drivers/misc/mei/client.h    |    5 +
 drivers/misc/mei/hw-me.c     |  376 ++++++++++++++++++++++++++++++----------
 drivers/misc/mei/hw-me.h     |   30 ++--
 drivers/misc/mei/init.c      |   58 +------
 drivers/misc/mei/interrupt.c |  130 +-------------
 drivers/misc/mei/main.c      |  363 ++------------------------------------
 drivers/misc/mei/mei_dev.h   |  168 +++++++++++++++---
 drivers/misc/mei/pci-me.c    |  396 ++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/wd.c        |    9 +-
 13 files changed, 960 insertions(+), 673 deletions(-)
 create mode 100644 drivers/misc/mei/pci-me.c

-- 
1.7.4.4

