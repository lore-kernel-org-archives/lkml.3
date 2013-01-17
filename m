Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3AQR15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:27:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31125 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3AQR1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:27:43 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, dan.magenheimer@oracle.com
Subject: [PATCH 0/5] staging: zcache: move new zcache code base from ramster
Date: Thu, 17 Jan 2013 09:26:32 -0800
Message-Id: <1358443597-9845-1-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg --

With "old zcache" now removed, we can now move "new zcache" from its
temporary home (in drivers/staging/ramster) to reclaim sole possession
of the name "zcache".

Note that [PATCH 2/5] will require a manual:

# git mv drivers/staging/ramster drivers/staging/zcache

so I have elided the 10000 line remove patch and 10000 line add patch
to save massive unnecessary cruft from the list servers.  If it would be
more convenient for you that I should post that full patch, please let
me know.

This patchset should apply cleanly to staging-next as of today.

Thanks,
Dan

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

---
Diffstat:

 drivers/staging/Kconfig                            |    4 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/ramster/Kconfig                    |   31 -
 drivers/staging/ramster/Makefile                   |    6 -
 drivers/staging/ramster/ramster.h                  |   59 -
 drivers/staging/ramster/ramster/heartbeat.c        |  462 ----
 drivers/staging/ramster/ramster/heartbeat.h        |   87 -
 drivers/staging/ramster/ramster/masklog.c          |  155 --
 drivers/staging/ramster/ramster/masklog.h          |  220 --
 drivers/staging/ramster/ramster/nodemanager.c      |  995 ---------
 drivers/staging/ramster/ramster/nodemanager.h      |   88 -
 drivers/staging/ramster/ramster/r2net.c            |  414 ----
 drivers/staging/ramster/ramster/ramster.c          |  985 ---------
 drivers/staging/ramster/ramster/ramster.h          |  161 --
 .../staging/ramster/ramster/ramster_nodemanager.h  |   39 -
 drivers/staging/ramster/ramster/tcp.c              | 2253 --------------------
 drivers/staging/ramster/ramster/tcp.h              |  159 --
 drivers/staging/ramster/ramster/tcp_internal.h     |  248 ---
 drivers/staging/ramster/tmem.c                     |  894 --------
 drivers/staging/ramster/tmem.h                     |  259 ---
 drivers/staging/ramster/zbud.c                     | 1060 ---------
 drivers/staging/ramster/zbud.h                     |   33 -
 drivers/staging/ramster/zcache-main.c              | 1820 ----------------
 drivers/staging/ramster/zcache.h                   |   53 -
 drivers/staging/zcache/Kconfig                     |   26 +
 drivers/staging/zcache/Makefile                    |    6 +
 drivers/staging/zcache/ramster.h                   |   59 +
 drivers/staging/zcache/ramster/heartbeat.c         |  462 ++++
 drivers/staging/zcache/ramster/heartbeat.h         |   87 +
 drivers/staging/zcache/ramster/masklog.c           |  155 ++
 drivers/staging/zcache/ramster/masklog.h           |  220 ++
 drivers/staging/zcache/ramster/nodemanager.c       |  995 +++++++++
 drivers/staging/zcache/ramster/nodemanager.h       |   88 +
 drivers/staging/zcache/ramster/r2net.c             |  414 ++++
 drivers/staging/zcache/ramster/ramster.c           |  985 +++++++++
 drivers/staging/zcache/ramster/ramster.h           |  161 ++
 .../staging/zcache/ramster/ramster_nodemanager.h   |   39 +
 drivers/staging/zcache/ramster/tcp.c               | 2253 ++++++++++++++++++++
 drivers/staging/zcache/ramster/tcp.h               |  159 ++
 drivers/staging/zcache/ramster/tcp_internal.h      |  248 +++
 drivers/staging/zcache/tmem.c                      |  894 ++++++++
 drivers/staging/zcache/tmem.h                      |  259 +++
 drivers/staging/zcache/zbud.c                      | 1060 +++++++++
 drivers/staging/zcache/zbud.h                      |   33 +
 drivers/staging/zcache/zcache-main.c               | 1820 ++++++++++++++++
 drivers/staging/zcache/zcache.h                    |   53 +
 46 files changed, 10479 insertions(+), 10484 deletions(-)
