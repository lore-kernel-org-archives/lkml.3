Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaISJWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:22:42 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40251 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaISJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:22:39 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, juri.lelli@gmail.com, raistlin@linux.it,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        daniel.wagner@bmw-carit.de, vincent@legout.info, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@arm.com>
Subject: [PATCH 0/3] SCHED_DEADLINE fix AC and SMP scheduling
Date: Fri, 19 Sep 2014 10:22:38 +0100
Message-Id: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.1.0
X-OriginalArrivalTime: 19 Sep 2014 09:22:34.0475 (UTC) FILETIME=[3EFFA3B0:01CFD3EB]
X-MC-Unique: 114091910223623901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8J9Mpce015341

Hello everyone,

This patchset fixes admission control, bandwidth management and
(clustered) SMP scheduling for SCHED_DEADLINE tasks.

Patch 1/3 properly clears things up when a task leaves SCHED_DEADLINE,
without dying (and it is a different solution for the problem spotted
by Daniel, http://marc.info/?l=linux-kernel&m=140974782707197&w=2);
patch 2/3 fixes how cpusets bandwidth is checked and updated; patch 3/3
fixes SMP (clustered) scheduling.

Best Regards,

- Juri

Juri Lelli (3):
  sched/deadline: clear dl_entity params when setscheduling to different
    class
  sched/deadline: fix bandwidth check/update when migrating tasks
    between exclusive cpusets
  sched/deadline: fix inter- exclusive cpusets migrations

 include/linux/sched.h      |  2 ++
 kernel/cpuset.c            | 13 ++-----
 kernel/sched/core.c        | 89 ++++++++++++++++++++++++++++++++++------------
 kernel/sched/cpudeadline.c |  4 +--
 kernel/sched/deadline.c    | 34 ++++++++++++++++--
 kernel/sched/sched.h       | 22 ++++++++++++
 6 files changed, 125 insertions(+), 39 deletions(-)

-- 
2.1.0


