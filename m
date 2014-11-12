Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaKLS7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:59:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbaKLS67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:58:59 -0500
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [RFC 0/4] OOM vs PM freezer fixes
Date: Wed, 12 Nov 2014 19:58:48 +0100
Message-Id: <1415818732-27712-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <20141110163055.GC18373@dhcp22.suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
here is another take at OOM vs. PM freezer interaction fixes/cleanups.
First three patches are fixes for an unlikely cases when OOM races with
the PM freezer which should be closed completely finally. The last patch
is a simple code enhancement which is not needed strictly speaking but
it is nice to have IMO.

Both OOM killer and PM freezer are quite subtle so I hope I haven't
missing anything. Any feedback is highly appreciated. I am also
interested about feedback for the used approach. To be honest I am not
really happy about spreading TIF_MEMDIE checks into freezer (patch 1)
but I didn't find any other way for detecting OOM killed tasks.

Changes are based on top of Linus tree (3.18-rc3).

Michal Hocko (4):
      OOM, PM: Do not miss OOM killed frozen tasks
      OOM, PM: make OOM detection in the freezer path raceless
      OOM, PM: handle pm freezer as an OOM victim correctly
      OOM: thaw the OOM victim if it is frozen

Diffstat says:
 drivers/tty/sysrq.c    |  6 ++--
 include/linux/oom.h    | 39 ++++++++++++++++------
 kernel/freezer.c       | 15 +++++++--
 kernel/power/process.c | 60 +++++++++-------------------------
 mm/memcontrol.c        |  4 ++-
 mm/oom_kill.c          | 89 ++++++++++++++++++++++++++++++++++++++------------
 mm/page_alloc.c        | 32 +++++++++---------
 7 files changed, 147 insertions(+), 98 deletions(-)

