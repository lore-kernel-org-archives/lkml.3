Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaGBXqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:46:03 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:34377 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaGBXqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:46:01 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.17] cgroup: remove sane_behavior support on non-default hierarchies
Date: Wed,  2 Jul 2014 19:45:43 -0400
Message-Id: <1404344747-7957-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

sane_behavior has been used as a development vehicle for the default
unified hierarchy.  Now that the default hierarchy is in place, the
flag became redundant and confusing as its usage is allowed on all
hierarchies.  There are gonna be either the default hierarchy or
legacy ones.  Let's make that clear by removing sane_behavior support
on non-default hierarchies.

This patchset contains the following four patches.

 0001-cgroup-remove-CGRP_ROOT_OPTION_MASK.patch
 0002-cgroup-make-interface-file-cgroup.sane_behavior-lega.patch
 0003-cgroup-remove-sane_behavior-support-on-non-default-h.patch
 0004-cgroup-clean-up-sane_behavior-handling.patch

0001 is a trivial cleanup.

0002 removes "cgroup.sane_behavior" from the default hierarchy.

0003 removes sane_behavior support on non-default hierarchies.

0004 cleans up sane_behavior handling.

This patchset is on top of a497c3ba1d97 ("Linux 3.16-rc2") and
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-dfl-instead-of-sane

diffstat follows.  Thanks.

 block/blk-throttle.c   |    6 +-
 include/linux/cgroup.h |  128 ++++++++++++++++++++-----------------------------
 kernel/cgroup.c        |   96 +++++++++++++++---------------------
 kernel/cpuset.c        |   33 +++++-------
 mm/memcontrol.c        |    7 +-
 5 files changed, 117 insertions(+), 153 deletions(-)

--
tejun
