Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaEHSHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:07:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:48750 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbaEHSHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:07:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1012,1389772800"; 
   d="scan'208";a="429590903"
From: Keith Busch <keith.busch@intel.com>
To: linux-nvme@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 0/2] Asynchronous device shutdown
Date: Thu,  8 May 2014 12:07:32 -0600
Message-Id: <1399572454-30239-1-git-send-email-keith.busch@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device shutdown synchronization was recently reverted due to complications
from unrelated 'async_schedule's holding up shutdown forever and the
fact that no device driver was making use of the capability anyway.

I would like to make use of this capability though; I'm told by some
vendors that devices I develop drivers for may take a while to safely
shutdown and there might be a lot of these devices in a machine, so we
would benefit from letting this happen in parallel.

This patch set adds a slightly different shutdown synchronization using
a new domain, and I've added an implementation to the nvm-express driver
here so there's at least one user, assuming this is acceptable.

Keith Busch (2):
  driver-core: allow asynchronous device shutdown
  NVMe: Complete shutdown asynchronously

 drivers/base/core.c       |    4 ++++
 drivers/block/nvme-core.c |   28 ++++++++++++++++++++++++++--
 include/linux/device.h    |    1 +
 include/linux/nvme.h      |    1 +
 4 files changed, 32 insertions(+), 2 deletions(-)

-- 
1.7.10.4

