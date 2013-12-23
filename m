Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab3LWRYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:24:39 -0500
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:52653 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757705Ab3LWRYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:24:35 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 23 Dec 2013 09:24:27 -0800
Message-Id: <1387819467-2825-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

for you to fetch changes up to 22f12c60e12a4112fdca31582e66fe501600ee2b:

  Merge branches 'cxgb4', 'flowsteer' and 'misc' into for-linus (2013-12-23 09:19:02 -0800)

----------------------------------------------------------------

Last batch of InfiniBand/RDMA changes for 3.13 / 2014:
 - Additional checks for uverbs to ensure forward compatibility, handle
   malformed input better.
 - Fix potential use-after-free in iWARP connection manager.
 - Make a function static.

----------------------------------------------------------------
Rashika (1):
      RDMA/cxgb4: Make _c4iw_write_mem_dma() static

Roland Dreier (2):
      IB/uverbs: New macro to set pointers to NULL if length is 0 in INIT_UDATA()
      Merge branches 'cxgb4', 'flowsteer' and 'misc' into for-linus

Steve Wise (1):
      RDMA/iwcm: Don't touch cm_id after deref in rem_ref

Yann Droneaud (7):
      IB/core: const'ify inbuf in struct ib_udata
      IB/uverbs: Check reserved field in extended command header
      IB/uverbs: Check comp_mask in destroy_flow
      IB/uverbs: Check reserved fields in create_flow
      IB/uverbs: Set error code when fail to consume all flow_spec items
      IB/uverbs: Check input length in flow steering uverbs
      IB/uverbs: Check access to userspace response buffer in extended command

 drivers/infiniband/core/iwcm.c        | 11 +++++++++--
 drivers/infiniband/core/uverbs.h      | 10 +++++++++-
 drivers/infiniband/core/uverbs_cmd.c  | 17 +++++++++++++++++
 drivers/infiniband/core/uverbs_main.c | 27 ++++++++++++++++-----------
 drivers/infiniband/hw/cxgb4/mem.c     |  2 +-
 include/rdma/ib_verbs.h               |  2 +-
 6 files changed, 53 insertions(+), 16 deletions(-)
