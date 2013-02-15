Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab3BOQzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:55:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab3BOQzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:55:47 -0500
Message-Id: <20130215165543.131282532@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Feb 2013 11:55:43 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v5 0/4] devcg: introduce proper hierarchy support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements device cgroup hierarchy. Exceptions will be
propagated down in the tree and local preferences will be re-evaluated
everytime a change in its parent occours, reapplying them if it's still
possible.

git://github.com/aristeu/linux-2.6.git
branch: devcg_hierarchy_review

v5:
- reworked the patchset to not propagate behavior changes

v4:
- minor fixes pointed by Tejun

v3:
- update documentation
- move css_online/css_offline changes to a new patch
- use cgroup_for_each_descendant_pre() instead of own descendant walk
- move exception_copy rework to a separared patch
- move exception_clean rework to a separated patch
- new patch to just move dev_exception_rm() before dev_exception_add()
  as requested by Tejun.
- updated patch description for may_access() changes
- new patch to expand the may_access() logic before changing it
- fixed argument description order in may_access()

v2:
- rebase on top "device_cgroup: don't grab mutex in rcu callback"
- in case parent changes behavior or exceptions and the local exceptions won't
  apply anymore, remove them instead of keeping them around.

Cc: Tejun Heo <tj@kernel.org>                                                                                               
Cc: Serge Hallyn <serge.hallyn@canonical.com>                                                                               
Signed-off-by: Aristeu Rozanski <aris@redhat.com>                                                                           

-- 
Aristeu
