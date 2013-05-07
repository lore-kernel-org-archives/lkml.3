Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab3EGBz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:55:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:20011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab3EGBzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:55:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="298596759"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 0/10] NTB: Bug Fixes 
Date: Mon,  6 May 2013 18:55:19 -0700
Message-Id: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches contains a number of bug fixes for the PCI-E Non-Transparent Bridge (NTB) device driver.

Some of these patches have been posted to LKML before, but I wanted all to be available for review prior to sending a pull request.

Thanks,
Jon

Dan Carpenter (2):
      ntb: off by one sanity checks
      NTB: fix pointer math issues

Jon Mason (8):
      NTB: variable dereferenced before check
      NTB: Handle 64bit BAR sizes
      NTB: Link toggle memory leak
      NTB: reset tx_index on link toggle
      NTB: Correctly handle receive buffers of the minimal size
      NTB: memcpy lockup workaround
      ntb_netdev: remove from list on exit
      NTB: Multiple NTB client fix

 drivers/net/ntb_netdev.c    |    2 +
 drivers/ntb/ntb_hw.c        |   10 +--
 drivers/ntb/ntb_transport.c |  175 ++++++++++++++++++++++++++++---------------
 3 files changed, 121 insertions(+), 66 deletions(-)

