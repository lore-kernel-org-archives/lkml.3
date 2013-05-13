Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3EMV6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:58:48 -0400
Received: from longford.logfs.org ([213.229.74.203]:59175 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab3EMV6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:58:42 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 0/3] target: Fix two races leading to use-after-free
Date: Mon, 13 May 2013 16:30:04 -0400
Message-Id: <1368477007-25274-1-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In our testing we've encountered use-after-free bugs, usually in the
shape of double list_del, at a rate of 2-10 per week.  Patches 2 and 3
fix two races that can both lead to use-after-free and after applying
both of those patches, we have been bug-free for some weeks now.

Patch 1 is an unrelated trivial cleanup.  I just happened to spot it
while I was in the area.

Joern Engel (3):
  target: removed unused transport_state flag
  target: close target_put_sess_cmd() vs. core_tmr_abort_task() race v5
  target: simplify target_wait_for_sess_cmds()

 drivers/infiniband/ulp/srpt/ib_srpt.c  |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    2 +-
 drivers/target/target_core_transport.c |   73 +++++++++-----------------------
 include/linux/kref.h                   |   33 +++++++++++++++
 include/target/target_core_base.h      |    3 --
 include/target/target_core_fabric.h    |    2 +-
 6 files changed, 57 insertions(+), 58 deletions(-)

-- 
1.7.10.4

