Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994Ab3EWN6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:58:34 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56850 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632Ab3EWN6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:58:33 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org
Subject: [PATCH v3 part1 0/4] Fix SG_IO ambiguity between READ SUBCHANNEL and UNMAP (and other similar cases)
Date: Thu, 23 May 2013 15:58:19 +0200
Message-Id: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SG_IO ioctl's command whitelist is designed for MMC devices (roughly,
"play/burn CDs without requiring root") but some opcodes overlap across SCSI
device classes and have different meanings for different classes.

To fix this, use different bitmaps for the various device classes.
This is CVE-2012-4542.

v2->v3: patches are now split differently, according to Tejun's indications;
	added conflict on operation code A4h.

Paolo Bonzini (4):
  sg_io: pass request_queue to blk_verify_command
  sg_io: prepare to introduce per-class command filters
  sg_io: use different default filters for each device class
  sg_io: resolve conflicts between commands assigned to multiple classes
    (CVE-2012-4542)

 block/bsg.c              |   2 +-
 block/scsi_ioctl.c       | 193 +++++++++++++++++++++++++++--------------------
 drivers/scsi/scsi_scan.c |   2 +
 drivers/scsi/sg.c        |   3 +-
 include/linux/blkdev.h   |   5 +-
 5 files changed, 118 insertions(+), 87 deletions(-)

-- 
1.8.1.4

