Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936119Ab3DICXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:23:41 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:47772 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933403Ab3DICXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:23:39 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net,
        eranian@google.com, namhyung.kim@lge.com, lizefan@huawei.com,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET] perf, cgroup: implement hierarchy support for perf_event controller
Date: Mon,  8 Apr 2013 19:23:30 -0700
Message-Id: <1365474213-13354-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event cgroup controller is one of the remaining few with broken
hierarchy support.  It turns out it's pretty easy to implement - the
only thing necessary is making perf_cgroup_match() return %true also
when the cgroup of the current task is a descendant of the event's
cgroup.  This patchset implements cgroup_is_descendant() and uses it
to implement hierarchy support in perf_event controller.

This patchset contains the following three patches.

 0001-cgroup-make-sure-parent-won-t-be-destroyed-before-it.patch
 0002-cgroup-implement-cgroup_is_descendant.patch
 0003-perf-make-perf_event-cgroup-hierarchical.patch

The patches are also available in the following git branch, which is
based on top of cgroup/for-3.10.  It's currently based on top of
cgroup/for-3.10 as the first patch causes non-trivial conflict with it
otherwise, which is not difficult to resolve but still nice to avoid
anyway.

Li, Michal, I picked the first two patches from Li's memcg patchset.
Can we push the first two through cgroup/for-3.10 and put the rest in
-mm?

Ingo, how should these be routed?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git perf_event-hierarchy-support

diffstat follows, thanks.

 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   30 ++++++++++++++++++++++++++++++
 kernel/events/core.c   |   24 ++++++++++++++++--------
 3 files changed, 47 insertions(+), 8 deletions(-)

--
tejun
