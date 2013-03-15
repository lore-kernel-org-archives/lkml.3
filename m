Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3COQvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:51:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22632 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab3COQvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:51:12 -0400
X-IronPort-AV: E=Sophos;i="4.84,852,1355068800"; 
   d="scan'208";a="6880044"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/9 for-3.10] srcu: use-site fix and cleanups
Date: Sat, 16 Mar 2013 00:50:48 +0800
Message-Id: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:49:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:49:45,
	Serialize complete at 2013/03/16 00:49:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All are simple cleanups(and one fix).

Patch1: fix imbalance srcu_read_[un]lock()
Patch2~6: use DEFINE[_STATIC]_SRCU macro
Patch7: use call_srcu() and remove a lot of code

Patch8~9: non-srcu related cleanup for fsnotify


Lai Jiangshan (9):
  powerpc,kvm: fix imbalance srcu_read_[un]lock()
  events: use DEFINE_STATIC_SRCU() to define pmus_srcu
  mmu_notifier: use DEFINE_STATIC_SRCU() to define srcu struct
  netpoll: use DEFINE_STATIC_SRCU() to define netpoll_srcu
  tomoyo: use DEFINE_SRCU() to define tomoyo_ss
  fsnotify: use DEFINE_SRCU() for srcu_struct
  fsnotify: use existed call_srcu()
  fsnotify: use BUILD_BUG_ON() to test ALL_FSNOTIFY_EVENTS
  fsnotify: remove fsnotify_init()

 arch/powerpc/kvm/book3s_hv.c     |    2 +-
 fs/notify/fsnotify.c             |   14 ---------
 fs/notify/mark.c                 |   61 +++++++-------------------------------
 fs/notify/notification.c         |    2 +
 include/linux/fsnotify_backend.h |    2 +-
 kernel/events/core.c             |    3 +-
 mm/mmu_notifier.c                |    8 +----
 net/core/netpoll.c               |    3 +-
 security/tomoyo/tomoyo.c         |    5 +--
 9 files changed, 20 insertions(+), 80 deletions(-)

-- 
1.7.4.4

