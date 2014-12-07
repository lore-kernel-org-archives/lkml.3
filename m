Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaLGKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 05:09:59 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58239 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaLGKJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 05:09:56 -0500
Date: Sun, 7 Dec 2014 11:09:53 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/4] OOM vs PM freezer fixes
Message-ID: <20141207100953.GC15892@dhcp22.suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417797707-31699-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason this is the previous version of the cover letter. I had
some issues with git send-email which was failing for me. Anyway, this
is the correct cover. Sorry about the cofusion.

Hi,
this is another attempt to address OOM vs. PM interaction. More
about the issue is described in the last patch. The other 4 patches
are just clean ups. This is based on top of 3.18-rc3 + Johannes'
http://marc.info/?l=linux-kernel&m=141779091114777 which is not in the
Andrew's tree yet but I wanted to prevent from later merge conflicts.

The previous version of the main patch (5th one) was posted here:
http://marc.info/?l=linux-mm&m=141634503316543&w=2. This version has
hopefully addressed all the points raised by Tejun in the previous
version. Namely
	- checkpatch fixes + printk -> pr_* changes in the respective
	  areas
	- more comments added to clarify subtle interactions
	- oom_killer_disable(), unmark_tsk_oom_victim changed into
	  wait_even API which is easier to use

Both OOM killer and the PM freezer are really subtle so I would really
appreciate a throughout review here. I still haven't changed lowmemory
killer which is abusing TIF_MEMDIE yet and it would break this code
(oom_victims counter balance) and I plan to look at it as soon as the
rest of the of the series is OK and agreed as a way to go. So there will
be at least one more patch for the final submission.

Thanks!

Michal Hocko (5):
      oom: add helpers for setting and clearing TIF_MEMDIE
      OOM: thaw the OOM victim if it is frozen
      PM: convert printk to pr_* equivalent
      sysrq: convert printk to pr_* equivalent
      OOM, PM: make OOM detection in the freezer path raceless

And diffstat:
 drivers/tty/sysrq.c    |  23 ++++----
 include/linux/oom.h    |  18 +++----
 kernel/exit.c          |   3 +-
 kernel/power/process.c |  81 +++++++++-------------------
 mm/memcontrol.c        |   4 +-
 mm/oom_kill.c          | 142 +++++++++++++++++++++++++++++++++++++++++++------
 mm/page_alloc.c        |  17 +-----
 7 files changed, 178 insertions(+), 110 deletions(-)

-- 
Michal Hocko
SUSE Labs
