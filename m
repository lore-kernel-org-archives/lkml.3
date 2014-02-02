Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaBBQej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:34:39 -0500
Received: from relay.parallels.com ([195.214.232.42]:46399 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaBBQd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:33:59 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH 0/8] memcg-vs-slab related fixes, improvements, cleanups
Date: Sun, 2 Feb 2014 20:33:45 +0400
Message-ID: <cover.1391356789.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.195]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set mostly cleanups memcg slab caches creation/destruction
paths fixing a couple of bugs in the meanwhile. However, it does
introduce some functional changes. First, it changes the memcg caches
naming convention (see patch 2). Second, it reworks sysfs layout for
memcg slub caches (see patch 6).

Comments are appreciated.

Thanks.

Vladimir Davydov (8):
  memcg: export kmemcg cache id via cgroup fs
  memcg, slab: remove cgroup name from memcg cache names
  memcg, slab: never try to merge memcg caches
  memcg, slab: separate memcg vs root cache creation paths
  slub: adjust memcg caches when creating cache alias
  slub: rework sysfs layout for memcg caches
  memcg, slab: unregister cache from memcg before starting to destroy
    it
  memcg, slab: do not destroy children caches if parent has aliases

 include/linux/memcontrol.h |   13 +--
 include/linux/slab.h       |    9 +-
 include/linux/slub_def.h   |    3 +
 mm/memcontrol.c            |   85 +++++++------------
 mm/slab.h                  |   36 ++++----
 mm/slab_common.c           |  194 ++++++++++++++++++++++++++++----------------
 mm/slub.c                  |  121 +++++++++++++++++++++------
 7 files changed, 277 insertions(+), 184 deletions(-)

-- 
1.7.10.4

