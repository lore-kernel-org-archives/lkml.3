Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966563Ab3DQSUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:20:30 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:33690 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965249Ab3DQSUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:20:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,495,1363132800"; 
   d="scan'208";a="3662947"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: [PATCH v2 0/7] xen-block: indirect descriptors
Date: Wed, 17 Apr 2013 20:18:54 +0200
Message-ID: <1366222741-39902-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementation of indirect descriptors v2, addressing Konrad's 
comments. A graph on performance can be found at:

http://xenbits.xen.org/people/royger/plot_indirect_read4k.png

Thanks for the review, Roger.

Roger Pau Monne (7):
      xen-blkback: print stats about persistent grants
      xen-blkback: use balloon pages for all mappings
      xen-blkback: implement LRU mechanism for persistent grants
      xen-blkback: move pending handles list from blkbk to pending_req
      xen-blkback: make the queue of free requests per backend
      xen-blkback: expand map/unmap functions
      xen-block: implement indirect descriptors

 Documentation/ABI/stable/sysfs-bus-xen-backend |   18 +
 drivers/block/xen-blkback/blkback.c            |  844 +++++++++++++++---------
 drivers/block/xen-blkback/common.h             |  145 ++++-
 drivers/block/xen-blkback/xenbus.c             |   39 ++
 drivers/block/xen-blkfront.c                   |  491 ++++++++++++---
 include/xen/interface/io/blkif.h               |   48 ++
 6 files changed, 1186 insertions(+), 399 deletions(-)

git://xenbits.xen.org/people/royger/linux.git xen-block-indirect-v2
