Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaCaT3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:29:18 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63015 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaCaT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:29:12 -0400
Date: Mon, 31 Mar 2014 15:29:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue changes for v3.15-rc1
Message-ID: <20140331192908.GB28901@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

PREPARE_[DELAYED_]WORK() were used to change the work function of work
items without fully reinitializing it; however, this makes workqueue
consider the work item as a different one from before and allows the
work item to start executing before the previous instance is finished
which can lead to extremely subtle issues which are painful to debug.
The interface has never been popular.  This pull request contains
patches to remove existing usages and kill the interface.  As one of
the changes was routed during the last devel cycle and another
depended on a pending change in nvme, for-3.15 contains a couple merge
commits.

In addition, interfaces which were deprecated quite a while ago -
__cancel_delayed_work() and WQ_NON_REENTRANT - are removed too.

The following changes since commit 70044d71d31d6973665ced5be04ef39ac1c09a48:

  firewire: don't use PREPARE_DELAYED_WORK (2014-03-07 10:19:57 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.15

for you to fetch changes up to 59ff3eb6d6f75c6c1c3ea8b46ac2cc64eb216547:

  workqueue: remove deprecated WQ_NON_REENTRANT (2014-03-29 09:33:03 -0400)

Thanks.

----------------------------------------------------------------
Geert Uytterhoeven (1):
      workqueue: Spelling s/instensive/intensive/

Tan Xiaojun (1):
      workqueue: Remove deprecated __cancel_delayed_work()

Tejun Heo (10):
      Merge branch 'wq/for-3.14-fixes' into wq/for-3.15
      Merge branch 'master' into wq/for-3.15
      wireless/rt2x00: don't use PREPARE_WORK in rt2800usb.c
      ps3-vuart: don't use PREPARE_WORK
      floppy: don't use PREPARE_[DELAYED_]WORK
      usb: don't use PREPARE_DELAYED_WORK
      nvme: don't use PREPARE_WORK
      afs: don't use PREPARE_WORK
      staging/fwserial: don't use PREPARE_WORK
      workqueue: remove PREPARE_[DELAYED_]WORK()

ZhangZhen (1):
      workqueue: remove deprecated WQ_NON_REENTRANT

 drivers/block/floppy.c                  |   42 +++++++++++++++++++++-----------
 drivers/block/nvme-core.c               |   18 +++++++++----
 drivers/mmc/host/dw_mmc.c               |    2 -
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 -
 drivers/ps3/ps3-vuart.c                 |    4 ---
 drivers/staging/fwserial/fwserial.c     |   13 +++++++--
 drivers/staging/fwserial/fwserial.h     |    1 
 drivers/usb/core/hub.c                  |    4 +--
 fs/afs/internal.h                       |    1 
 fs/afs/rxrpc.c                          |   12 +++++++--
 include/linux/nvme.h                    |    1 
 include/linux/workqueue.h               |   38 ++--------------------------
 net/l2tp/l2tp_core.c                    |    2 -
 13 files changed, 72 insertions(+), 68 deletions(-)

-- 
tejun
