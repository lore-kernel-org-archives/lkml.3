Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3A3J00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:26:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab3A3J0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:26:24 -0500
From: Hannes Reinecke <hare@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stefan Weinhuber <wein@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/9][v2] dasd: implement block timeout
Date: Wed, 30 Jan 2013 10:26:10 +0100
Message-Id: <1359537979-39483-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements a block timeout handler for
DASDs. The main impetus was to allow for a fixed upper
timeout value after which a request is aborted.
This is required eg when implementing a host-based
mirroring system where otherwise the entire mirror
would stall under certain circumstances.

Changes since v1:
- Fixed lock inversion in dasd_times_out()
- Checked for 'device->block' when writing to 'timeout' attribute
- Check against 'UINT_MAX' when verifying the 'timeout' value

Hannes Reinecke (9):
  dasd: Clarify comment
  dasd: make number of retries configurable
  dasd: process all requests in the device tasklet
  dasd: Implement block timeout handling
  dasd: Reduce amount of messages for specific errors
  dasd: detailed I/O errors
  block: check for timeout function in blk_rq_timed_out()
  dasd: Add 'timeout' attribute
  dasd: Fail all requests when DASD_FLAG_ABORTIO is set

 arch/s390/include/uapi/asm/dasd.h |    4 +
 block/blk-core.c                  |    3 +
 block/blk-timeout.c               |    5 +-
 drivers/s390/block/dasd.c         |  115 +++++++++++++++++++++++++++++++++----
 drivers/s390/block/dasd_devmap.c  |   97 +++++++++++++++++++++++++++++++
 drivers/s390/block/dasd_diag.c    |    8 ++-
 drivers/s390/block/dasd_eckd.c    |   15 ++++-
 drivers/s390/block/dasd_erp.c     |    8 +++
 drivers/s390/block/dasd_fba.c     |   10 +++-
 drivers/s390/block/dasd_int.h     |   10 +++
 drivers/s390/block/dasd_ioctl.c   |   59 +++++++++++++++++++
 11 files changed, 313 insertions(+), 21 deletions(-)

-- 
1.7.4.2

