Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab3CYQmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:42:13 -0400
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:37336 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757925Ab3CYQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:42:11 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 25 Mar 2013 09:42:03 -0700
Message-Id: <1364229723-6092-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Small batch of InfiniBand/RDMA fixes for 3.9:

 - Fix for TX lockup in IPoIB
 - QLogic -> Intel update for qib driver
 - Small static checker fix for qib
 - Fix error path return value in cxgb4

----------------------------------------------------------------
Dan Carpenter (1):
      IB/ipath: Silence a static checker warning

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion

Roland Dreier (1):
      Merge branches 'cxgb4', 'ipoib' and 'qib' into for-next

Vinit Agnihotri (1):
      IB/qib: change QLogic to Intel

Wei Yongjun (1):
      RDMA/cxgb4: Fix error return code in create_qp()

 drivers/infiniband/hw/cxgb4/qp.c          | 4 +++-
 drivers/infiniband/hw/ipath/ipath_verbs.c | 2 +-
 drivers/infiniband/hw/qib/Kconfig         | 6 +++---
 drivers/infiniband/hw/qib/qib_driver.c    | 5 +++--
 drivers/infiniband/hw/qib/qib_iba6120.c   | 3 ++-
 drivers/infiniband/hw/qib/qib_init.c      | 8 ++++----
 drivers/infiniband/hw/qib/qib_sd7220.c    | 4 ++--
 drivers/infiniband/hw/qib/qib_verbs.c     | 4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 8 ++++++--
 firmware/Makefile                         | 2 +-
 firmware/{qlogic => intel}/sd7220.fw.ihex | 0
 11 files changed, 27 insertions(+), 19 deletions(-)
 rename firmware/{qlogic => intel}/sd7220.fw.ihex (100%)
