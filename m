Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbaCRUxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:53:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:13521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681AbaCRUxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172297"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 00/13] mei: add runtime pm
Date: Tue, 18 Mar 2014 22:51:54 +0200
Message-Id: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Usyskin (2):
  mei: txe: add runtime pm framework
  mei: txe: use runtime PG pm domain for non wakeable devices

Tomas Winkler (11):
  mei: implement power gating isolation hbm layer
  mei: me: introduce power gating registers
  mei: me: add power gating isolation register write wrappers
  mei: condition PGI support on HW and HBM version
  mei: expose hardware power gating state to mei layer
  mei: me: add pg exit and entry flow commands
  mei: add function to check write queues
  mei: me: add runtime pm framework
  mei: use runtime pm in write and read flow
  mei: me: use runtime PG pm domain for non wakeable devices
  mei: me: bump hbm version to 1.1 to support power gating

 drivers/misc/mei/client.c     |  84 +++++++++++++++++----
 drivers/misc/mei/hbm.c        |  51 +++++++++++++
 drivers/misc/mei/hbm.h        |   1 +
 drivers/misc/mei/hw-me-regs.h |   9 +++
 drivers/misc/mei/hw-me.c      | 171 +++++++++++++++++++++++++++++++++++++++++-
 drivers/misc/mei/hw-me.h      |   6 ++
 drivers/misc/mei/hw-txe.c     |  57 +++++++++++---
 drivers/misc/mei/hw-txe.h     |  16 ++--
 drivers/misc/mei/hw.h         |  25 +++++-
 drivers/misc/mei/init.c       |  24 ++++++
 drivers/misc/mei/mei_dev.h    |  54 +++++++++++++
 drivers/misc/mei/pci-me.c     | 142 ++++++++++++++++++++++++++++++++++-
 drivers/misc/mei/pci-txe.c    | 150 +++++++++++++++++++++++++++++++++++-
 13 files changed, 748 insertions(+), 42 deletions(-)

-- 
1.8.5.3

