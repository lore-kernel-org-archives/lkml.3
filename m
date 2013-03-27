Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab3C0LMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:12:23 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:22412 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3C0LMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:12:21 -0400
X-IronPort-AV: E=Sophos;i="4.84,917,1355097600"; 
   d="scan'208";a="2955620"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: [PATCH v1 0/7] xen-block: indirect descriptors
Date: Wed, 27 Mar 2013 12:10:36 +0100
Message-ID: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the patches in the previous series, that were bugfixes or code 
cleanups, are already committed, so the series is a little bit 
smaller.

Previous performance graph was wrong because I had a bunch of 
debugging options enabled when performing the tests. The following 
graph contains a more accurate comparison:

http://xenbits.xen.org/people/royger/plot_indirect_read4k.png

Also, the default number of segments per indirect request has been set 
to 32 in order to map them all persistently, but this can be changed 
at runtime by the user.

Roger Pau Monne (7):
      xen-blkback: print stats about persistent grants
      xen-blkback: use balloon pages for all mappings
      xen-blkback: implement LRU mechanism for persistent grants
      xen-blkback: move pending handles list from blkbk to pending_req
      xen-blkback: make the queue of free requests per backend
      xen-blkback: expand map/unmap functions
      xen-block: implement indirect descriptors

 Documentation/ABI/stable/sysfs-bus-xen-backend |   15 +
 drivers/block/xen-blkback/blkback.c            |  833 +++++++++++++++---------
 drivers/block/xen-blkback/common.h             |  120 ++++-
 drivers/block/xen-blkback/xenbus.c             |   32 +
 drivers/block/xen-blkfront.c                   |  490 ++++++++++++---
 include/xen/interface/io/blkif.h               |   26 +
 6 files changed, 1122 insertions(+), 394 deletions(-)

git://xenbits.xen.org/people/royger/linux.git xen-block-indirect-v1
