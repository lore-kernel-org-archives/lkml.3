Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaFEOBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:01:16 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaFEOAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:00:54 -0400
From: Richard Weinberger <richard@nod.at>
To: hannes@cmpxchg.org
Cc: mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org,
        handai.szj@taobao.com, rientjes@google.com, oleg@redhat.com,
        rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: oom: Be less verbose
Date: Thu,  5 Jun 2014 16:00:40 +0200
Message-Id: <1401976841-3899-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Processes within Linux containers very often hit their memory limits.
This has the side effect that the kernel log gets spammed all day with
useless OOM messages.
If a userspace program listens to the memory cgroup event fd to
get notified upon OOM we can avoid this spamming and be less verbose.

With this patch applied the OOM killer will only print much details
if nobody listens to the affected memory cgroup event fd.
I can also think of a new sysctl like "vm.oom_verbose=1" to guarantee the old
behavior even if we have listeners.

What do you think?

Thanks,
//richard

[RFC][PATCH] oom: Be less verbose if the oom_control event fd has listeners
--
 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |   20 ++++++++++++++++++++
 mm/oom_kill.c              |    2 +-
 3 files changed, 27 insertions(+), 1 deletion(-)

