Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3CDM67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:58:59 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37929 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab3CDM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:58:57 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -v3 00/23] rename random32 to prandom
Date: Mon,  4 Mar 2013 21:58:08 +0900
Message-Id: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 496f2f93b1cc286f5a4f4f9acdc1e5314978683f ("random32: rename random32
to prandom") renamed random32() and srandom32() to prandom_u32() and
prandom_seed() respectively.  Due to the volume of existing random32()
callers, they were preserved as backword compatibility wrapper macros.

This patch series aims for finishing the naming transition and removing
the backword compatibility wrapper macros.

The naming transition is mainly simple substitution work for random32()
and srandom32().  But this patch series also includes minor cleanup
which was found while I was working on the substitution.

* Changes from v2
- ubifs, batman-adv, and mtd patches are merged upstream
- add Acked-by: and Reviewed-by: lines
- add rename for brcm80211

* Changes from v1
- leave all net_random() and net_srandom callers as-is and preserve the
  macro definisions. Because that is a useful indirection.
  Spotted by Neil Horman.
- remove batman-adv fix which has been applied to net
- collect Acked-by:

Akinobu Mita (23):
  raid6test: use prandom_bytes()
  uuid: use prandom_bytes()
  x86: pageattr-test: remove srandom32 call
  x86: rename random32() to prandom_u32()
  lib/: rename random32() to prandom_u32()
  mm/: rename random32() to prandom_u32()
  kernel/: rename random32() to prandom_u32()
  drbd: rename random32() to prandom_u32()
  infiniband: rename random32() to prandom_u32()
  mmc: rename random32() to prandom_u32()
  video/uvesafb: rename random32() to prandom_u32()
  xfs: rename random32() to prandom_u32()
  uwb: rename random32() to prandom_u32()
  lguest: rename random32() to prandom_u32()
  scsi: rename random32() to prandom_u32()
  drivers/net: rename random32() to prandom_u32()
  net/sunrpc: rename random32() to prandom_u32()
  net/sched: rename random32() to prandom_u32()
  net/netfilter: rename random32() to prandom_u32()
  net/core:  rename random32() to prandom_u32()
  net/core: remove duplicate statements by do-while loop
  net: rename random32 to prandom
  remove unused random32() and srandom32()

 arch/x86/mm/pageattr-test.c                   |  5 ++--
 crypto/async_tx/raid6test.c                   |  9 ++----
 drivers/block/drbd/drbd_receiver.c            |  5 ++--
 drivers/infiniband/hw/cxgb3/cxio_resource.c   |  4 +--
 drivers/infiniband/hw/cxgb4/id_table.c        |  4 +--
 drivers/infiniband/hw/mlx4/mad.c              |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |  2 +-
 drivers/lguest/page_tables.c                  |  2 +-
 drivers/mmc/core/core.c                       |  4 +--
 drivers/net/ethernet/broadcom/cnic.c          |  4 +--
 drivers/net/hamradio/baycom_epp.c             |  2 +-
 drivers/net/hamradio/hdlcdrv.c                |  2 +-
 drivers/net/hamradio/yam.c                    |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |  2 +-
 drivers/net/wireless/mwifiex/cfg80211.c       |  4 +--
 drivers/scsi/fcoe/fcoe_ctlr.c                 |  4 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c              |  6 ++--
 drivers/scsi/qla2xxx/qla_attr.c               |  7 +++--
 drivers/uwb/rsv.c                             |  4 +--
 drivers/video/uvesafb.c                       |  2 +-
 fs/xfs/xfs_alloc.c                            |  2 +-
 fs/xfs/xfs_error.c                            |  2 +-
 fs/xfs/xfs_ialloc.c                           |  2 +-
 fs/xfs/xfs_log.c                              |  2 +-
 include/linux/net.h                           |  4 +--
 include/linux/random.h                        |  7 -----
 kernel/rcutree.c                              |  2 +-
 kernel/test_kprobes.c                         |  2 +-
 lib/fault-inject.c                            |  2 +-
 lib/list_sort.c                               |  2 +-
 lib/uuid.c                                    |  8 +----
 mm/swapfile.c                                 |  2 +-
 net/core/pktgen.c                             | 42 +++++++++++++--------------
 net/netfilter/nf_conntrack_core.c             |  4 +--
 net/sched/sch_choke.c                         |  2 +-
 net/sunrpc/auth_gss/gss_krb5_wrap.c           |  4 +--
 36 files changed, 74 insertions(+), 91 deletions(-)

-- 
1.8.1.2

