Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaDVGa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:30:26 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58733 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaDVGaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:30:22 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, lizefan@huawei.com, nasa4836@gmail.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] cgroup: substitude per-cgroup id with per-subsys id
Date: Tue, 22 Apr 2014 14:30:09 +0800
Message-Id: <cover.1398147734.git.nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, cgrp->id is only used to look up css's.  As cgroup and
css's lifetimes is now decoupled, it should be made per-subsystem
and moved to css->css_id so that lookups are successful until the
target css is released.

Patch 1-3 are prep patches.
Patch 4 do the coverting job.

Thanks!

Jianyu Zhan (4):
  cgroup: introduce helper css_to_id()
  mm/memcontrol.c: use accessor to get id from css
  netprio_cgroup: use accessor to get id from css
  cgroup: convert from per-cgroup id to per-subsys id

 include/linux/cgroup.h    | 27 ++++++-------
 kernel/cgroup.c           | 96 +++++++++++++++++++++++++----------------------
 mm/memcontrol.c           |  8 ++--
 net/core/netprio_cgroup.c |  8 ++--
 4 files changed, 74 insertions(+), 65 deletions(-)

-- 
2.0.0-rc0

