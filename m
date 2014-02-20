Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaBTHYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:24:04 -0500
Received: from relay.parallels.com ([195.214.232.42]:45658 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaBTHWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:22:17 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <mhocko@suse.cz>, <akpm@linux-foundation.org>
CC: <rientjes@google.com>, <penberg@kernel.org>, <cl@linux.com>,
        <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH -mm v3 0/7] memcg-vs-slab related fixes, improvements, cleanups
Date: Thu, 20 Feb 2014 11:22:02 +0400
Message-ID: <cover.1392879001.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set mostly cleanups memcg slab caches creation/destruction
paths fixing a couple of bugs in the meanwhile. The only serious change
it introduces is a rework of the sysfs layout for memcg slub caches (see
patch 7).

Changes in v3 (thanks to Michal Hocko):
 - improve patch descriptions
 - overall cleanup
 - rebase onto v3.14-rc3
Changes in v2 (thanks to David Rientjes):
 - do not remove cgroup name part from memcg cache names
 - do not export memcg cache id to userspace

Thanks,

Vladimir Davydov (7):
  memcg, slab: never try to merge memcg caches
  memcg, slab: cleanup memcg cache creation
  memcg, slab: separate memcg vs root cache creation paths
  memcg, slab: unregister cache from memcg before starting to destroy
    it
  memcg, slab: do not destroy children caches if parent has aliases
  slub: adjust memcg caches when creating cache alias
  slub: rework sysfs layout for memcg caches

 include/linux/memcontrol.h |    9 +-
 include/linux/slab.h       |    6 +-
 include/linux/slub_def.h   |    3 +
 mm/memcontrol.c            |  109 ++++++++-----------
 mm/slab.h                  |   21 +---
 mm/slab_common.c           |  250 +++++++++++++++++++++++++++-----------------
 mm/slub.c                  |   58 ++++++++--
 7 files changed, 261 insertions(+), 195 deletions(-)

-- 
1.7.10.4

