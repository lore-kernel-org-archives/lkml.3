Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab3JZSHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 14:07:51 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:40694 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3JZSHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 14:07:49 -0400
Message-ID: <1382811414.19256.744.camel@haakon3.risingtidesystems.com>
Subject: [GIT PULL] target fixes for v3.12-rc7
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Glanzmann <thomas@glanzmann.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Date: Sat, 26 Oct 2013 11:16:54 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus!

Here are the outstanding target pending fixes for v3.12-rc7.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

It includes a number of EXTENDED_COPY related fixes as a result of
Thomas and Doug's continuing testing and feedback.

Also included is an important vhost/scsi fix that addresses a long
standing issue where the 'write' parameter for get_user_pages_fast() was
incorrectly set for virtio-scsi WRITEs -> DMA_TO_DEVICE, and not for
virtio-scsi READs -> DMA_FROM_DEVICE.

This resulted in random userspace segfaults and other unpleasantness on
KVM host, and unfortunately has been an issue since the initial merge of
vhost/scsi in v3.6.  This patch is CC'ed to stable, along with two other
less critical items.

Thank you,

--nab

Nicholas Bellinger (7):
  target: Make target_do_xcopy failures return INVALID_PARAMETER_LIST
  target: Allow non zero ListID in EXTENDED_COPY parameter list
  target: Reject EXTENDED_COPY when emulate_3pc is disabled
  target: Add missing XCOPY I/O operation sense_buffer
  target: Generate failure for XCOPY I/O with non-zero scsi_status
  target: Fail XCOPY for non matching source + destination block_size
  vhost/scsi: Fix incorrect usage of get_user_pages_fast write
    parameter

Roland Dreier (2):
  target: Fix assignment of LUN in tracepoints
  target: Return an error for WRITE SAME with ANCHOR==1

Vu Pham (1):
  iser-target: check device before dereferencing its variable

Wei Yongjun (1):
  target/pscsi: fix return value check

 drivers/infiniband/ulp/isert/ib_isert.c |    2 +-
 drivers/target/target_core_pscsi.c      |    8 ++--
 drivers/target/target_core_sbc.c        |    5 +++
 drivers/target/target_core_xcopy.c      |   53 +++++++++++++++++++++---------
 drivers/vhost/scsi.c                    |    2 +-
 include/trace/events/target.h           |    4 +-
 6 files changed, 50 insertions(+), 24 deletions(-)

