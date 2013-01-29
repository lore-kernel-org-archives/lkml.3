Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab3A2TIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:08:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab3A2TID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:08:03 -0500
Message-Id: <20130129190759.117458287@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 29 Jan 2013 14:07:59 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v3 0/9] devcg: introduce proper hierarchy support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements device cgroup hierarchy. Behaviors and exceptions
will be propagated down in the tree and local preferences will be re-evaluated
everytime a change in its parent occours, reapplying them if it's still
possible.

git://github.com/aristeu/linux-2.6.git
branch: devcg_hierarchy_review

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
