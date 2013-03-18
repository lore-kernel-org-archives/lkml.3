Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3CRQvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:51:19 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:57578 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3CRQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:51:15 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355097600"; 
   d="scan'208";a="2617147"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] xen-block: cleanup and fixes
Date: Mon, 18 Mar 2013 17:49:31 +0100
Message-ID: <1363625376-35612-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains the cleanups and fixes found in my previous 
indirect descriptors series, that are aimed for linux 3.9.

Available in the git repository at:
  git://xenbits.xen.org/people/royger/linux.git blk-for-3.9

Roger Pau Monne (5):
      xen-blkback: don't store dev_bus_addr
      xen-blkback: fix foreach_grant_safe to handle empty lists
      xen-blkfront: switch from llist to list
      xen-blkfront: pre-allocate pages for requests
      xen-blkfront: remove frame list from blk_shadow

 drivers/block/xen-blkback/blkback.c |   19 +---
 drivers/block/xen-blkback/common.h  |    1 -
 drivers/block/xen-blkfront.c        |  151 +++++++++++++++++++++--------------
 3 files changed, 95 insertions(+), 76 deletions(-)
