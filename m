Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaJXJQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:16:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37735 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaJXJQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:16:52 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: juri.lelli@gmail.com, mingo@redhat.com, daniel.wagner@bmw-carit.de,
        vincent@legout.info, Juri Lelli <juri.lelli@arm.com>
Subject: [PATCH 0/4] Fix various bits of AC and PI for SCHED_DEADLINE
Date: Fri, 24 Oct 2014 10:16:34 +0100
Message-Id: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.1.2
X-OriginalArrivalTime: 24 Oct 2014 09:16:49.0435 (UTC) FILETIME=[3DCBF6B0:01CFEF6B]
X-MC-Unique: 114102410165006301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id s9O9Gxa8022054

Hi all,

this is basically a resend of 4 patches fixing problems around AC
and PI related to SCHED_DEADLINE. You can find the full story here:

 - https://lkml.org/lkml/2014/9/19/134
 - https://lkml.org/lkml/2014/9/24/493

First two patches fix AC. They are the same as the previous version,
plus aligning to commit f10e00f4bf36 ("sched/dl: Use dl_bw_of() under
rcu_read_lock_sched()"). Last two fix PI.

Thanks a lot again to Daniel for spending time fixing and testing
the PI stuff! And to Peter and Vincent for reviews and comments.

Best Regards,

- Juri

Juri Lelli (4):
  sched/deadline: fix bandwidth check/update when migrating tasks
    between exclusive cpusets
  sched/deadline: ensure that updates to exclusive cpusets don't break
    AC
  sched/deadline: don't replenish from a !SCHED_DEADLINE entity
  sched/deadline: fix races between rt_mutex_setprio and dl_task_timer

 include/linux/sched.h   |  4 +++
 kernel/cpuset.c         | 23 ++++++------
 kernel/sched/core.c     | 94 +++++++++++++++++++++++++++++++++++++++----------
 kernel/sched/deadline.c | 58 +++++++++++++++++++++++++-----
 kernel/sched/sched.h    | 19 ++++++++++
 5 files changed, 160 insertions(+), 38 deletions(-)

-- 
2.1.2


